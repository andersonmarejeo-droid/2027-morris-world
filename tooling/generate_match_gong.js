const fs = require('node:fs');
const path = require('node:path');

const sampleRate = 44100;
const duration = 2.15;
const sampleCount = Math.floor(sampleRate * duration);
const outputPath = path.resolve(__dirname, '../assets/audio/match_gong.wav');
const partials = [
  [111, 0.28, 1.65],
  [166, 0.23, 1.30],
  [223, 0.22, 1.82],
  [291, 0.18, 1.45],
  [337, 0.16, 1.96],
  [451, 0.13, 1.14],
  [539, 0.11, 1.63],
  [687, 0.085, 1.02],
  [853, 0.060, 0.88],
  [1097, 0.035, 0.70],
];

const data = Buffer.alloc(sampleCount * 2);
let seed = 351043;
let peak = 0;
const samples = new Float64Array(sampleCount);

for (let i = 0; i < sampleCount; i++) {
  const time = i / sampleRate;
  const strike = Math.min(1, time / 0.012);
  const swell = 0.76 + 0.24 * Math.exp(-time * 4.1);
  let value = 0;

  for (let p = 0; p < partials.length; p++) {
    const [frequency, gain, decay] = partials[p];
    const detune = 1 + 0.0014 * Math.sin(time * (1.2 + p * 0.13));
    const phase = p * 0.41;
    value += gain * Math.exp(-time / decay) * Math.sin(2 * Math.PI * frequency * detune * time + phase);
  }

  seed ^= seed << 13;
  seed ^= seed >>> 17;
  seed ^= seed << 5;
  const noise = (seed >>> 0) / 0xffffffff * 2 - 1;
  const softAttack = noise * 0.045 * Math.exp(-time / 0.018);
  const fadeStart = duration - 0.22;
  const endFade = time <= fadeStart ? 1 : 0.5 - 0.5 * Math.cos(Math.PI * (duration - time) / 0.22);
  value = (value * strike * swell + softAttack) * endFade;
  samples[i] = value;
  peak = Math.max(peak, Math.abs(value));
}

const scale = 0.82 / peak;
for (let i = 0; i < sampleCount; i++) {
  const pcm = Math.max(-1, Math.min(1, samples[i] * scale));
  data.writeInt16LE(Math.round(pcm * 32767), i * 2);
}

const header = Buffer.alloc(44);
header.write('RIFF', 0);
header.writeUInt32LE(36 + data.length, 4);
header.write('WAVE', 8);
header.write('fmt ', 12);
header.writeUInt32LE(16, 16);
header.writeUInt16LE(1, 20);
header.writeUInt16LE(1, 22);
header.writeUInt32LE(sampleRate, 24);
header.writeUInt32LE(sampleRate * 2, 28);
header.writeUInt16LE(2, 32);
header.writeUInt16LE(16, 34);
header.write('data', 36);
header.writeUInt32LE(data.length, 40);

fs.writeFileSync(outputPath, Buffer.concat([header, data]));
process.stdout.write(`Created ${outputPath} (${duration.toFixed(2)} seconds)\n`);
