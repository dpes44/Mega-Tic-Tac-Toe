#!/usr/bin/env python3
import math
import os
import struct
import wave


SAMPLE_RATE = 22050


def _clamp_sample(value: float) -> int:
    value = max(-1.0, min(1.0, value))
    return int(value * 32767)


def _write_wav(path: str, samples):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with wave.open(path, "wb") as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(SAMPLE_RATE)
        frames = b"".join(struct.pack("<h", _clamp_sample(s)) for s in samples)
        wav.writeframes(frames)


def generate_tap_beep(path: str):
    duration = 0.14
    total = int(SAMPLE_RATE * duration)
    frequency = 920.0
    samples = []
    for i in range(total):
        t = i / SAMPLE_RATE
        # Soft attack/release envelope.
        env = math.sin(math.pi * min(1.0, i / (total * 0.2)))
        env *= math.sin(math.pi * min(1.0, (total - i) / (total * 0.35)))
        tone = math.sin(2.0 * math.pi * frequency * t)
        samples.append(0.28 * tone * env)
    _write_wav(path, samples)


def _note_hz(note: int) -> float:
    return 440.0 * (2.0 ** ((note - 69) / 12.0))


def generate_background_music(path: str):
    # 12-second loop: warm chord progression.
    bars = [
        [57, 60, 64],  # A3 C4 E4
        [53, 57, 60],  # F3 A3 C4
        [55, 59, 62],  # G3 B3 D4
        [52, 55, 59],  # E3 G3 B3
    ]
    bar_seconds = 3.0
    total_seconds = bar_seconds * len(bars)
    total = int(SAMPLE_RATE * total_seconds)
    samples = [0.0 for _ in range(total)]

    for bar_index, chord in enumerate(bars):
        start = int(bar_index * bar_seconds * SAMPLE_RATE)
        end = int((bar_index + 1) * bar_seconds * SAMPLE_RATE)
        bar_len = end - start

        for i in range(bar_len):
            t = i / SAMPLE_RATE
            absolute_i = start + i
            # Smooth bar envelope.
            attack = min(1.0, i / (SAMPLE_RATE * 0.45))
            release = min(1.0, (bar_len - i) / (SAMPLE_RATE * 0.55))
            env = attack * release

            mix = 0.0
            for idx, note in enumerate(chord):
                freq = _note_hz(note)
                phase_mod = 1.0 + 0.0025 * math.sin(2.0 * math.pi * 0.18 * t + idx)
                mix += (0.33 - idx * 0.05) * math.sin(
                    2.0 * math.pi * (freq * phase_mod) * t
                )

            # Gentle high sparkle and low pad to avoid sounding flat.
            mix += 0.06 * math.sin(2.0 * math.pi * 2.0 * t)
            mix += 0.04 * math.sin(2.0 * math.pi * 0.33 * t)
            samples[absolute_i] += mix * env * 0.34

    # Overall fade in/out so loop boundaries are softer.
    fade = int(SAMPLE_RATE * 0.35)
    for i in range(fade):
        samples[i] *= i / fade
        samples[-(i + 1)] *= i / fade

    _write_wav(path, samples)


if __name__ == "__main__":
    generate_tap_beep("assets/audio/tap_beep.wav")
    generate_background_music("assets/audio/background_music.wav")
    print("Generated assets/audio/tap_beep.wav")
    print("Generated assets/audio/background_music.wav")
