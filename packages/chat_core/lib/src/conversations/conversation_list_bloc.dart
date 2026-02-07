import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:provider_api/provider_api.dart';
import 'conversation_list_state.dart';
import 'load_conversations_use_case.dart';

import 'mark_conversation_read_use_case.dart';

abstract class ConversationListEvent extends Equatable {
  const ConversationListEvent();
  @override
  List<Object?> get props => [];
}

class ConversationListLoadInitial extends ConversationListEvent {}

class ConversationListLoadMore extends ConversationListEvent {}

class ConversationListRefresh extends ConversationListEvent {}

class ConversationListSearch extends ConversationListEvent {
  final String query;
  const ConversationListSearch(this.query);
  @override
  List<Object?> get props => [query];
}

class ConversationListSelect extends ConversationListEvent {
  final String conversationId;
  const ConversationListSelect(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}

class ConversationListHandleUpdate extends ConversationListEvent {
  final Conversation conversation;
  const ConversationListHandleUpdate(this.conversation);
  @override
  List<Object?> get props => [conversation];
}

class ConversationListBloc extends Bloc<ConversationListEvent, ConversationListState> {
  final LoadConversationsUseCase _loadUseCase;
  final MarkConversationReadUseCase _markReadUseCase;
  String? _nextCursor;

  ConversationListBloc({required LoadConversationsUseCase loadUseCase, required MarkConversationReadUseCase markReadUseCase})
    : _loadUseCase = loadUseCase,
      _markReadUseCase = markReadUseCase,
      super(const ConversationListState()) {
    on<ConversationListLoadInitial>(_onLoadInitial);
    on<ConversationListLoadMore>(_onLoadMore);
    on<ConversationListRefresh>(_onRefresh);
    on<ConversationListSearch>(_onSearch);
    on<ConversationListSelect>(_onSelect);
    on<ConversationListHandleUpdate>(_onHandleUpdate);
  }

  Future<void> _onLoadInitial(ConversationListLoadInitial event, Emitter<ConversationListState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final page = await _loadUseCase.execute(limit: 20, query: state.searchQuery);
      _nextCursor = page.nextCursor;
      emit(state.copyWith(items: page.items, isLoading: false, hasMore: page.hasMore));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onLoadMore(ConversationListLoadMore event, Emitter<ConversationListState> emit) async {
    if (!state.hasMore || state.isLoading) return;

    try {
      final page = await _loadUseCase.execute(cursor: _nextCursor, limit: 20, query: state.searchQuery);
      _nextCursor = page.nextCursor;
      emit(state.copyWith(items: [...state.items, ...page.items], hasMore: page.hasMore));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onRefresh(ConversationListRefresh event, Emitter<ConversationListState> emit) async {
    _nextCursor = null;
    add(ConversationListLoadInitial());
  }

  Future<void> _onSearch(ConversationListSearch event, Emitter<ConversationListState> emit) async {
    emit(state.copyWith(searchQuery: event.query));
    _nextCursor = null;
    add(ConversationListLoadInitial());
  }

  Future<void> _onSelect(ConversationListSelect event, Emitter<ConversationListState> emit) async {
    final index = state.items.indexWhere((c) => c.id == event.conversationId);
    if (index != -1 && state.items[index].unreadCount > 0) {
      final newItems = List<Conversation>.from(state.items);
      newItems[index] = newItems[index].copyWith(unreadCount: 0);
      emit(state.copyWith(items: newItems));

      try {
        await _markReadUseCase.execute(event.conversationId);
      } catch (_) {}
    }
  }

  Future<void> _onHandleUpdate(ConversationListHandleUpdate event, Emitter<ConversationListState> emit) async {
    final index = state.items.indexWhere((c) => c.id == event.conversation.id);
    if (index != -1) {
      final newItems = List<Conversation>.from(state.items);
      newItems[index] = event.conversation;
      emit(state.copyWith(items: newItems));
    } else {
      if (state.searchQuery == null) {
        emit(state.copyWith(items: [event.conversation, ...state.items]));
      }
    }
  }
}
