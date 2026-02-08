use std::ffi::CString;

use flutter_embedder_sys::{
    FlutterKeyEvent, FlutterKeyEventDeviceType_kFlutterKeyEventDeviceTypeKeyboard,
    FlutterKeyEventType, FlutterKeyEventType_kFlutterKeyEventTypeDown,
    FlutterKeyEventType_kFlutterKeyEventTypeRepeat, FlutterKeyEventType_kFlutterKeyEventTypeUp,
};
use winit::{
    event::{ElementState, KeyEvent},
    keyboard::{Key, KeyCode, KeyLocation, NamedKey, NativeKey, NativeKeyCode, PhysicalKey},
};

const LOGICAL_VALUE_MASK: u64 = 0x0000_0fff_ffff;

const LOGICAL_UNIDENTIFIED: u64 = 0x0001_0000_0001;
const LOGICAL_SHIFT_LEFT: u64 = 0x0002_0000_0102;
const LOGICAL_SHIFT_RIGHT: u64 = 0x0002_0000_0103;
const LOGICAL_ALT_LEFT: u64 = 0x0002_0000_0104;
const LOGICAL_ALT_RIGHT: u64 = 0x0002_0000_0105;
const LOGICAL_META_LEFT: u64 = 0x0002_0000_0106;
const LOGICAL_META_RIGHT: u64 = 0x0002_0000_0107;
const LOGICAL_CONTROL_LEFT: u64 = 0x0002_0000_0100;
const LOGICAL_CONTROL_RIGHT: u64 = 0x0002_0000_0101;

const LOGICAL_SHIFT: u64 = 0x0002_0000_01f2;
const LOGICAL_ALT: u64 = 0x0002_0000_01f4;
const LOGICAL_META: u64 = 0x0002_0000_01f6;
const LOGICAL_CONTROL: u64 = 0x0002_0000_01f0;

const LOGICAL_NUMPAD_ENTER: u64 = 0x0002_0000_020d;
const LOGICAL_NUMPAD_MULTIPLY: u64 = 0x0002_0000_022a;
const LOGICAL_NUMPAD_ADD: u64 = 0x0002_0000_022b;
const LOGICAL_NUMPAD_SUBTRACT: u64 = 0x0002_0000_022d;
const LOGICAL_NUMPAD_DECIMAL: u64 = 0x0002_0000_022e;
const LOGICAL_NUMPAD_DIVIDE: u64 = 0x0002_0000_022f;
const LOGICAL_NUMPAD_0: u64 = 0x0002_0000_0230;
const LOGICAL_NUMPAD_1: u64 = 0x0002_0000_0231;
const LOGICAL_NUMPAD_2: u64 = 0x0002_0000_0232;
const LOGICAL_NUMPAD_3: u64 = 0x0002_0000_0233;
const LOGICAL_NUMPAD_4: u64 = 0x0002_0000_0234;
const LOGICAL_NUMPAD_5: u64 = 0x0002_0000_0235;
const LOGICAL_NUMPAD_6: u64 = 0x0002_0000_0236;
const LOGICAL_NUMPAD_7: u64 = 0x0002_0000_0237;
const LOGICAL_NUMPAD_8: u64 = 0x0002_0000_0238;
const LOGICAL_NUMPAD_9: u64 = 0x0002_0000_0239;
const LOGICAL_NUMPAD_EQUAL: u64 = 0x0002_0000_023d;

const LOGICAL_ANDROID_PLANE: u64 = 0x0011_0000_0000;
const LOGICAL_MACOS_PLANE: u64 = 0x0014_0000_0000;
const LOGICAL_GTK_PLANE: u64 = 0x0015_0000_0000;
const LOGICAL_WINDOWS_PLANE: u64 = 0x0016_0000_0000;
const LOGICAL_WEB_PLANE: u64 = 0x0017_0000_0000;

pub struct PreparedKeyEvent {
    pub event: FlutterKeyEvent,
    _character_storage: Option<CString>,
}

pub fn prepare_key_event(key_event: &KeyEvent, timestamp_micros: usize) -> PreparedKeyEvent {
    let event_type = map_key_event_type(key_event.state, key_event.repeat);
    let logical = map_logical_key(key_event);
    let physical = map_physical_key(key_event.physical_key);

    let character_storage = if event_type == FlutterKeyEventType_kFlutterKeyEventTypeUp {
        None
    } else {
        key_event
            .text
            .as_ref()
            .and_then(|text| sanitize_text_for_cstring(text.as_str()))
    };

    let character = character_storage
        .as_ref()
        .map_or(std::ptr::null(), |text| text.as_ptr());

    let event = FlutterKeyEvent {
        struct_size: std::mem::size_of::<FlutterKeyEvent>(),
        timestamp: timestamp_micros as f64,
        type_: event_type,
        physical,
        logical,
        character,
        synthesized: false,
        device_type: FlutterKeyEventDeviceType_kFlutterKeyEventDeviceTypeKeyboard,
        ..Default::default()
    };

    PreparedKeyEvent {
        event,
        _character_storage: character_storage,
    }
}

fn sanitize_text_for_cstring(text: &str) -> Option<CString> {
    if text.is_empty() {
        return None;
    }

    let sanitized: String = text.chars().filter(|c| *c != '\0').collect();
    if sanitized.is_empty() {
        None
    } else {
        CString::new(sanitized).ok()
    }
}

fn map_key_event_type(state: ElementState, repeat: bool) -> FlutterKeyEventType {
    match state {
        ElementState::Released => FlutterKeyEventType_kFlutterKeyEventTypeUp,
        ElementState::Pressed if repeat => FlutterKeyEventType_kFlutterKeyEventTypeRepeat,
        ElementState::Pressed => FlutterKeyEventType_kFlutterKeyEventTypeDown,
    }
}

fn map_logical_key(key_event: &KeyEvent) -> u64 {
    let mapped = match key_event.logical_key.as_ref() {
        Key::Character(text) => map_logical_character(text, key_event.location),
        Key::Named(named) => map_named_key(named, key_event.location),
        Key::Unidentified(native) => logical_from_native_key(&native),
        Key::Dead(Some(ch)) => u64::from(ch),
        Key::Dead(None) => LOGICAL_UNIDENTIFIED,
    };

    if mapped == 0 {
        LOGICAL_UNIDENTIFIED
    } else {
        mapped
    }
}

fn map_logical_character(text: &str, location: KeyLocation) -> u64 {
    let Some(mut ch) = text.chars().next() else {
        return LOGICAL_UNIDENTIFIED;
    };

    if ch.is_ascii_alphabetic() {
        ch = ch.to_ascii_lowercase();
    }

    if location == KeyLocation::Numpad {
        return match ch {
            '0' => LOGICAL_NUMPAD_0,
            '1' => LOGICAL_NUMPAD_1,
            '2' => LOGICAL_NUMPAD_2,
            '3' => LOGICAL_NUMPAD_3,
            '4' => LOGICAL_NUMPAD_4,
            '5' => LOGICAL_NUMPAD_5,
            '6' => LOGICAL_NUMPAD_6,
            '7' => LOGICAL_NUMPAD_7,
            '8' => LOGICAL_NUMPAD_8,
            '9' => LOGICAL_NUMPAD_9,
            '+' => LOGICAL_NUMPAD_ADD,
            '-' => LOGICAL_NUMPAD_SUBTRACT,
            '*' => LOGICAL_NUMPAD_MULTIPLY,
            '/' => LOGICAL_NUMPAD_DIVIDE,
            '.' | ',' => LOGICAL_NUMPAD_DECIMAL,
            '=' => LOGICAL_NUMPAD_EQUAL,
            _ => u64::from(ch),
        };
    }

    u64::from(ch)
}

fn map_named_key(named: NamedKey, location: KeyLocation) -> u64 {
    match named {
        NamedKey::Backspace => 0x0001_0000_0008,
        NamedKey::Tab => 0x0001_0000_0009,
        NamedKey::Enter => {
            if location == KeyLocation::Numpad {
                LOGICAL_NUMPAD_ENTER
            } else {
                0x0001_0000_000d
            }
        }
        NamedKey::Escape => 0x0001_0000_001b,
        NamedKey::Delete => 0x0001_0000_007f,
        NamedKey::Space => 0x0000_0000_0020,
        NamedKey::CapsLock => 0x0001_0000_0104,
        NamedKey::NumLock => 0x0001_0000_010a,
        NamedKey::ScrollLock => 0x0001_0000_010c,
        NamedKey::ArrowDown => 0x0001_0000_0301,
        NamedKey::ArrowLeft => 0x0001_0000_0302,
        NamedKey::ArrowRight => 0x0001_0000_0303,
        NamedKey::ArrowUp => 0x0001_0000_0304,
        NamedKey::End => 0x0001_0000_0305,
        NamedKey::Home => 0x0001_0000_0306,
        NamedKey::PageDown => 0x0001_0000_0307,
        NamedKey::PageUp => 0x0001_0000_0308,
        NamedKey::Insert => 0x0001_0000_0407,
        NamedKey::ContextMenu => 0x0001_0000_0505,
        NamedKey::Pause => 0x0001_0000_0509,
        NamedKey::PrintScreen => 0x0001_0000_0608,
        NamedKey::Shift => match location {
            KeyLocation::Left => LOGICAL_SHIFT_LEFT,
            KeyLocation::Right => LOGICAL_SHIFT_RIGHT,
            _ => LOGICAL_SHIFT,
        },
        NamedKey::Control => match location {
            KeyLocation::Left => LOGICAL_CONTROL_LEFT,
            KeyLocation::Right => LOGICAL_CONTROL_RIGHT,
            _ => LOGICAL_CONTROL,
        },
        NamedKey::Alt => match location {
            KeyLocation::Left => LOGICAL_ALT_LEFT,
            KeyLocation::Right => LOGICAL_ALT_RIGHT,
            _ => LOGICAL_ALT,
        },
        NamedKey::Meta | NamedKey::Super => match location {
            KeyLocation::Left => LOGICAL_META_LEFT,
            KeyLocation::Right => LOGICAL_META_RIGHT,
            _ => LOGICAL_META,
        },
        NamedKey::F1 => 0x0001_0000_0801,
        NamedKey::F2 => 0x0001_0000_0802,
        NamedKey::F3 => 0x0001_0000_0803,
        NamedKey::F4 => 0x0001_0000_0804,
        NamedKey::F5 => 0x0001_0000_0805,
        NamedKey::F6 => 0x0001_0000_0806,
        NamedKey::F7 => 0x0001_0000_0807,
        NamedKey::F8 => 0x0001_0000_0808,
        NamedKey::F9 => 0x0001_0000_0809,
        NamedKey::F10 => 0x0001_0000_080a,
        NamedKey::F11 => 0x0001_0000_080b,
        NamedKey::F12 => 0x0001_0000_080c,
        NamedKey::F13 => 0x0001_0000_080d,
        NamedKey::F14 => 0x0001_0000_080e,
        NamedKey::F15 => 0x0001_0000_080f,
        NamedKey::F16 => 0x0001_0000_0810,
        NamedKey::F17 => 0x0001_0000_0811,
        NamedKey::F18 => 0x0001_0000_0812,
        NamedKey::F19 => 0x0001_0000_0813,
        NamedKey::F20 => 0x0001_0000_0814,
        NamedKey::F21 => 0x0001_0000_0815,
        NamedKey::F22 => 0x0001_0000_0816,
        NamedKey::F23 => 0x0001_0000_0817,
        NamedKey::F24 => 0x0001_0000_0818,
        _ => LOGICAL_UNIDENTIFIED,
    }
}

fn logical_from_native_key(native: &NativeKey) -> u64 {
    match native {
        NativeKey::Unidentified => LOGICAL_UNIDENTIFIED,
        NativeKey::Android(code) => LOGICAL_ANDROID_PLANE | (u64::from(*code) & LOGICAL_VALUE_MASK),
        NativeKey::MacOS(code) => LOGICAL_MACOS_PLANE | (u64::from(*code) & LOGICAL_VALUE_MASK),
        NativeKey::Windows(code) => LOGICAL_WINDOWS_PLANE | (u64::from(*code) & LOGICAL_VALUE_MASK),
        NativeKey::Xkb(code) => LOGICAL_GTK_PLANE | (u64::from(*code) & LOGICAL_VALUE_MASK),
        NativeKey::Web(key) => {
            LOGICAL_WEB_PLANE | (hash_key_value(key.as_str()) & LOGICAL_VALUE_MASK)
        }
    }
}

fn hash_key_value(value: &str) -> u64 {
    let mut hash = 0xcbf2_9ce4_8422_2325_u64;
    for byte in value.as_bytes() {
        hash ^= u64::from(*byte);
        hash = hash.wrapping_mul(0x1000_0000_01b3);
    }
    hash
}

fn map_physical_key(key: PhysicalKey) -> u64 {
    match key {
        PhysicalKey::Code(code) => map_key_code_to_physical_usage(code),
        PhysicalKey::Unidentified(native) => map_native_physical(native),
    }
}

fn map_native_physical(native: NativeKeyCode) -> u64 {
    match native {
        NativeKeyCode::Unidentified => 0x0007_0000,
        NativeKeyCode::Android(code) => 0x0007_0000 | (u64::from(code) & 0xffff),
        NativeKeyCode::MacOS(code) => 0x0007_0000 | (u64::from(code) & 0xffff),
        NativeKeyCode::Windows(code) => 0x0007_0000 | (u64::from(code) & 0xffff),
        NativeKeyCode::Xkb(code) => 0x0007_0000 | (u64::from(code) & 0xffff),
    }
}

fn map_key_code_to_physical_usage(code: KeyCode) -> u64 {
    match code {
        KeyCode::Backquote => 0x0007_0035,
        KeyCode::Backslash => 0x0007_0031,
        KeyCode::BracketLeft => 0x0007_002f,
        KeyCode::BracketRight => 0x0007_0030,
        KeyCode::Comma => 0x0007_0036,
        KeyCode::Digit0 => 0x0007_0027,
        KeyCode::Digit1 => 0x0007_001e,
        KeyCode::Digit2 => 0x0007_001f,
        KeyCode::Digit3 => 0x0007_0020,
        KeyCode::Digit4 => 0x0007_0021,
        KeyCode::Digit5 => 0x0007_0022,
        KeyCode::Digit6 => 0x0007_0023,
        KeyCode::Digit7 => 0x0007_0024,
        KeyCode::Digit8 => 0x0007_0025,
        KeyCode::Digit9 => 0x0007_0026,
        KeyCode::Equal => 0x0007_002e,
        KeyCode::IntlBackslash => 0x0007_0064,
        KeyCode::IntlRo => 0x0007_0087,
        KeyCode::IntlYen => 0x0007_0089,
        KeyCode::KeyA => 0x0007_0004,
        KeyCode::KeyB => 0x0007_0005,
        KeyCode::KeyC => 0x0007_0006,
        KeyCode::KeyD => 0x0007_0007,
        KeyCode::KeyE => 0x0007_0008,
        KeyCode::KeyF => 0x0007_0009,
        KeyCode::KeyG => 0x0007_000a,
        KeyCode::KeyH => 0x0007_000b,
        KeyCode::KeyI => 0x0007_000c,
        KeyCode::KeyJ => 0x0007_000d,
        KeyCode::KeyK => 0x0007_000e,
        KeyCode::KeyL => 0x0007_000f,
        KeyCode::KeyM => 0x0007_0010,
        KeyCode::KeyN => 0x0007_0011,
        KeyCode::KeyO => 0x0007_0012,
        KeyCode::KeyP => 0x0007_0013,
        KeyCode::KeyQ => 0x0007_0014,
        KeyCode::KeyR => 0x0007_0015,
        KeyCode::KeyS => 0x0007_0016,
        KeyCode::KeyT => 0x0007_0017,
        KeyCode::KeyU => 0x0007_0018,
        KeyCode::KeyV => 0x0007_0019,
        KeyCode::KeyW => 0x0007_001a,
        KeyCode::KeyX => 0x0007_001b,
        KeyCode::KeyY => 0x0007_001c,
        KeyCode::KeyZ => 0x0007_001d,
        KeyCode::Minus => 0x0007_002d,
        KeyCode::Period => 0x0007_0037,
        KeyCode::Quote => 0x0007_0034,
        KeyCode::Semicolon => 0x0007_0033,
        KeyCode::Slash => 0x0007_0038,
        KeyCode::AltLeft => 0x0007_00e2,
        KeyCode::AltRight => 0x0007_00e6,
        KeyCode::Backspace => 0x0007_002a,
        KeyCode::CapsLock => 0x0007_0039,
        KeyCode::ContextMenu => 0x0007_0065,
        KeyCode::ControlLeft => 0x0007_00e0,
        KeyCode::ControlRight => 0x0007_00e4,
        KeyCode::Enter => 0x0007_0028,
        KeyCode::SuperLeft => 0x0007_00e3,
        KeyCode::SuperRight => 0x0007_00e7,
        KeyCode::ShiftLeft => 0x0007_00e1,
        KeyCode::ShiftRight => 0x0007_00e5,
        KeyCode::Space => 0x0007_002c,
        KeyCode::Tab => 0x0007_002b,
        KeyCode::Delete => 0x0007_004c,
        KeyCode::End => 0x0007_004d,
        KeyCode::Home => 0x0007_004a,
        KeyCode::Insert => 0x0007_0049,
        KeyCode::PageDown => 0x0007_004e,
        KeyCode::PageUp => 0x0007_004b,
        KeyCode::ArrowDown => 0x0007_0051,
        KeyCode::ArrowLeft => 0x0007_0050,
        KeyCode::ArrowRight => 0x0007_004f,
        KeyCode::ArrowUp => 0x0007_0052,
        KeyCode::NumLock => 0x0007_0053,
        KeyCode::Numpad0 => 0x0007_0062,
        KeyCode::Numpad1 => 0x0007_0059,
        KeyCode::Numpad2 => 0x0007_005a,
        KeyCode::Numpad3 => 0x0007_005b,
        KeyCode::Numpad4 => 0x0007_005c,
        KeyCode::Numpad5 => 0x0007_005d,
        KeyCode::Numpad6 => 0x0007_005e,
        KeyCode::Numpad7 => 0x0007_005f,
        KeyCode::Numpad8 => 0x0007_0060,
        KeyCode::Numpad9 => 0x0007_0061,
        KeyCode::NumpadAdd => 0x0007_0057,
        KeyCode::NumpadDecimal => 0x0007_0063,
        KeyCode::NumpadDivide => 0x0007_0054,
        KeyCode::NumpadEnter => 0x0007_0058,
        KeyCode::NumpadEqual => 0x0007_0067,
        KeyCode::NumpadMultiply => 0x0007_0055,
        KeyCode::NumpadSubtract => 0x0007_0056,
        KeyCode::Escape => 0x0007_0029,
        KeyCode::PrintScreen => 0x0007_0046,
        KeyCode::ScrollLock => 0x0007_0047,
        KeyCode::Pause => 0x0007_0048,
        KeyCode::F1 => 0x0007_003a,
        KeyCode::F2 => 0x0007_003b,
        KeyCode::F3 => 0x0007_003c,
        KeyCode::F4 => 0x0007_003d,
        KeyCode::F5 => 0x0007_003e,
        KeyCode::F6 => 0x0007_003f,
        KeyCode::F7 => 0x0007_0040,
        KeyCode::F8 => 0x0007_0041,
        KeyCode::F9 => 0x0007_0042,
        KeyCode::F10 => 0x0007_0043,
        KeyCode::F11 => 0x0007_0044,
        KeyCode::F12 => 0x0007_0045,
        KeyCode::F13 => 0x0007_0068,
        KeyCode::F14 => 0x0007_0069,
        KeyCode::F15 => 0x0007_006a,
        KeyCode::F16 => 0x0007_006b,
        KeyCode::F17 => 0x0007_006c,
        KeyCode::F18 => 0x0007_006d,
        KeyCode::F19 => 0x0007_006e,
        KeyCode::F20 => 0x0007_006f,
        KeyCode::F21 => 0x0007_0070,
        KeyCode::F22 => 0x0007_0071,
        KeyCode::F23 => 0x0007_0072,
        KeyCode::F24 => 0x0007_0073,
        _ => 0x0007_0000,
    }
}
