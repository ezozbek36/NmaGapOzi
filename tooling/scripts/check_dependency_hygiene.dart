#!/usr/bin/env dart

import 'dart:io';

enum DependencyStyle { any, inline, map, path, workspace }

final _importRegex = RegExp(r'''(?:import|export)\s+['"]package:([A-Za-z0-9_]+)/''');

class Dependency {
  Dependency({required this.name, required this.style, required this.lineNumber, required this.isFlutterSdk});

  final String name;
  final DependencyStyle style;
  final int lineNumber;
  final bool isFlutterSdk;
}

class PackageManifest {
  PackageManifest({required this.name, required this.path, required this.pubspecPath, required this.dependencies});

  final String name;
  final String path;
  final String pubspecPath;
  final List<Dependency> dependencies;
}

void main() {
  final rootPubspec = File('pubspec.yaml');
  if (!rootPubspec.existsSync()) {
    stderr.writeln('Could not find root pubspec.yaml. Run this script from repository root.');
    exitCode = 1;
    return;
  }

  final workspaceMembers = _parseWorkspaceMembers(rootPubspec.readAsLinesSync());
  if (workspaceMembers.isEmpty) {
    stderr.writeln('No workspace members found in root pubspec.yaml.');
    exitCode = 1;
    return;
  }

  final manifests = <PackageManifest>[];
  for (final member in workspaceMembers) {
    final pubspecPath = '$member/pubspec.yaml';
    final pubspec = File(pubspecPath);
    if (!pubspec.existsSync()) {
      stderr.writeln('Missing workspace member manifest: $pubspecPath');
      exitCode = 1;
      return;
    }

    final lines = pubspec.readAsLinesSync();
    manifests.add(
      PackageManifest(
        name: _parsePackageName(lines, pubspecPath),
        path: member,
        pubspecPath: pubspecPath,
        dependencies: _parseDependencies(lines),
      ),
    );
  }

  final internalPackages = manifests.map((m) => m.name).toSet();
  final violations = <String>[];

  for (final manifest in manifests) {
    final referencedPackages = _collectReferencedPackages(Directory(manifest.path));

    for (final dependency in manifest.dependencies) {
      if (dependency.isFlutterSdk) {
        continue;
      }

      if (internalPackages.contains(dependency.name) && dependency.style != DependencyStyle.any) {
        violations.add(
          '${manifest.pubspecPath}:${dependency.lineNumber}: internal dependency "${dependency.name}" must use "any" (workspace policy).',
        );
      }

      if (dependency.name == manifest.name) {
        continue;
      }

      if (!referencedPackages.contains(dependency.name)) {
        violations.add(
          '${manifest.pubspecPath}:${dependency.lineNumber}: dependency "${dependency.name}" is declared but not imported from lib/, bin/, or tool/.',
        );
      }
    }
  }

  if (violations.isNotEmpty) {
    stderr.writeln('Dependency hygiene check failed:');
    for (final violation in violations) {
      stderr.writeln('- $violation');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Dependency hygiene check passed for ${manifests.length} workspace members.');
}

Set<String> _collectReferencedPackages(Directory packageRoot) {
  final referenced = <String>{};

  for (final subdir in ['lib', 'bin', 'tool']) {
    final directory = Directory('${packageRoot.path}/$subdir');
    if (!directory.existsSync()) {
      continue;
    }

    for (final entity in directory.listSync(recursive: true, followLinks: false)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }

      final content = entity.readAsStringSync();
      for (final match in _importRegex.allMatches(content)) {
        referenced.add(match.group(1)!);
      }
    }
  }

  return referenced;
}

String _parsePackageName(List<String> lines, String filePath) {
  final match = lines.map((line) => RegExp(r'''^name:\s*['"]?([^'"]+)['"]?\s*$''').firstMatch(line)).whereType<RegExpMatch>().firstOrNull;

  if (match == null) {
    stderr.writeln('Could not parse package name in $filePath');
    exitCode = 1;
    throw StateError('Could not parse package name in $filePath');
  }

  return match.group(1)!.trim();
}

List<String> _parseWorkspaceMembers(List<String> lines) {
  final members = <String>[];
  var inWorkspace = false;

  for (final line in lines) {
    final trimmed = line.trim();
    if (!inWorkspace) {
      if (trimmed == 'workspace:') {
        inWorkspace = true;
      }
      continue;
    }

    if (trimmed.isEmpty || trimmed.startsWith('#')) {
      continue;
    }

    if (!line.startsWith('  ')) {
      break;
    }

    final match = RegExp(r'^  -\s+(.+?)\s*$').firstMatch(line);
    if (match != null) {
      members.add(match.group(1)!.trim());
      continue;
    }

    if (!line.startsWith('    ')) {
      break;
    }
  }

  return members;
}

List<Dependency> _parseDependencies(List<String> lines) {
  final deps = <Dependency>[];
  final start = lines.indexWhere((line) => line.trim() == 'dependencies:');
  if (start == -1) {
    return deps;
  }

  for (var i = start + 1; i < lines.length; i++) {
    final line = lines[i];

    if (_isTopLevelLine(line)) {
      break;
    }

    final depMatch = RegExp(r'^  ([A-Za-z0-9_]+):(.*)$').firstMatch(line);
    if (depMatch == null) {
      continue;
    }

    final name = depMatch.group(1)!;
    final remainder = depMatch.group(2)!.trim();
    final lineNumber = i + 1;

    if (remainder.isNotEmpty) {
      deps.add(
        Dependency(
          name: name,
          style: remainder == 'any' ? DependencyStyle.any : DependencyStyle.inline,
          lineNumber: lineNumber,
          isFlutterSdk: false,
        ),
      );
      continue;
    }

    final nestedLines = <String>[];
    var j = i + 1;
    for (; j < lines.length; j++) {
      final nested = lines[j];
      if (_isTopLevelLine(nested)) {
        break;
      }
      if (RegExp(r'^  [A-Za-z0-9_]+:').hasMatch(nested)) {
        break;
      }
      nestedLines.add(nested.trim());
    }

    final hasPath = nestedLines.any((line) => line.startsWith('path:'));
    final hasWorkspace = nestedLines.any((line) => line.startsWith('workspace:'));
    final isFlutterSdk = name == 'flutter' && nestedLines.any((line) => line == 'sdk: flutter');

    deps.add(
      Dependency(
        name: name,
        style: hasPath
            ? DependencyStyle.path
            : hasWorkspace
            ? DependencyStyle.workspace
            : DependencyStyle.map,
        lineNumber: lineNumber,
        isFlutterSdk: isFlutterSdk,
      ),
    );

    i = j - 1;
  }

  return deps;
}

bool _isTopLevelLine(String line) {
  if (line.startsWith(' ') || line.trim().isEmpty || line.trim().startsWith('#')) {
    return false;
  }

  return RegExp(r'^[A-Za-z_][A-Za-z0-9_-]*:').hasMatch(line);
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    for (final value in this) {
      return value;
    }
    return null;
  }
}
