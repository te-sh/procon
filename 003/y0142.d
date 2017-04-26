import std.algorithm, std.conv, std.range, std.stdio, std.string;

alias ulong T;
const sz = 64;

version(unittest) {} else
void main()
{
  auto rd = readln.split;
  auto n = rd[0].to!size_t, seed = rd[1].to!long, x = rd[2].to!long, y = rd[3].to!long, z = rd[4].to!long;

  auto bsz = (n + sz - 1) / sz;

  auto ai = new long[](bsz * sz);
  ai[0] = seed;
  foreach (i; 1..n)
    ai[i] = (ai[i-1] * x + y) % z;

  auto bi = new T[](bsz + 1);

  foreach (i; 0..bsz) {
    auto r = T(0);
    auto ci = ai[i*sz..(i+1)*sz];
    foreach_reverse (c; ci) {
      r <<= 1;
      r |= c % 2;
    }
    bi[i] = r;
  }

  auto q = readln.chomp.to!size_t;
  foreach (_; 0..q) {
    auto rd2 = readln.split.to!(size_t[]).map!"a - 1";
    auto s = rd2[0], t = rd2[1], u = rd2[2], v = rd2[3];

    auto sd = s / sz, sm = s % sz, td = t / sz, tm = t % sz;
    auto ud = u / sz, um = u % sz, vd = v / sz, vm = v % sz;

    auto ci = new T[](td - sd + 2);
    foreach (i; sd..td+1) {
      auto b = bi[i];
      if (i == sd) b &= ~((T(1) << sm) - 1);
      if (i == td && tm + 1 < sz) b &= (T(1) << (tm + 1)) - 1;
      ci[i - sd] = b;
    }

    if (sm < um) {
      foreach_reverse(i, c; ci) {
        ci[i] <<= (um - sm);
        if (i > 0)
          ci[i] |= (ci[i - 1] >> (sz - (um - sm)));
      }
    } else if (sm > um) {
      foreach (i, c; ci) {
        ci[i] >>= (sm - um);
        if (i < ci.length - 1)
          ci[i] |= (ci[i + 1] << (sz - (sm - um)));
      }
    }

    foreach (i; ud..vd+1)
      bi[i] ^= ci[i - ud];
  }

  foreach (i, b; bi)
    foreach (j; 0..sz) {
      if (i * sz + j >= n) break;
      write(predSwitch(b & 1, 0, 'E', 1, 'O'));
      b >>= 1;
    }
  writeln;
}
