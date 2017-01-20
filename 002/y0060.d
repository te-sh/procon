import std.algorithm, std.conv, std.range, std.stdio, std.string;

const auto ofs = 500, maxX = 500 + ofs + 1, maxY = 500 + ofs + 1;

version(unittest) {} else
void main()
{
  auto rd1 = readln.split.to!(size_t[]), n = rd1[0], k = rd1[1];
  Monster[] mi = n.iota.map!((_) {
    auto rd2 = readln.split;
    return Monster(rd2[0].to!int + ofs, rd2[1].to!int + ofs, rd2[2].to!long);
  }).array;

  auto fij = new long[][](maxY, maxX);
  foreach (_; k.iota) {
    auto rd3 = readln.split;
    auto x = rd3[0].to!int + ofs, y = rd3[1].to!int + ofs;
    auto w = rd3[2].to!int, h = rd3[3].to!int, d = rd3[4].to!long;

    auto x2 = x + w + 1, y2 = y + h + 1;

    fij[y][x] += d;
    if (x2 < maxX) fij[y][x2] -= d;
    if (y2 < maxY) fij[y2][x] -= d;
    if (x2 < maxX && y2 < maxY) fij[y2][x2] += d;
  }

  foreach (x; 1..maxX)
    foreach (y; 0..maxY)
      fij[y][x] += fij[y][x - 1];
  foreach (y; 1..maxY)
    foreach (x; 0..maxX)
      fij[y][x] += fij[y - 1][x];

  auto r = 0L;
  foreach (m; mi) {
    auto h = m.hp - fij[m.y][m.x];
    if (h > 0) r += h;
  }

  writeln(r);
}

struct Monster {
  int x, y;
  long hp;
}
