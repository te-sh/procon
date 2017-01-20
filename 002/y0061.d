import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.math;      // math functions
import std.numeric;   // gcd

version(unittest) {} else
void main()
{
  auto q = readln.chomp.to!size_t;

  foreach (_1; q.iota) {
    auto rd = readln.split.to!(int[]);
    auto w = rd[0], h = rd[1], d = rd[2], mx = rd[3], my = rd[4];
    auto hx = rd[5], hy = rd[6], vx = rd[7], vy = rd[8];

    auto g = gcd(vx.abs, vy.abs), ux = vx / g, uy = vy / g;
    auto w2 = w * 2, h2 = h * 2;
    auto fij = new bool[][](h2, w2);

    auto bx = hx, by = hy;
    foreach (_2; (d * g).iota) {
      bx = ((bx + ux) % w2 + w2) % w2;
      by = ((by + uy) % h2 + h2) % h2;
      if (fij[by][bx]) break;
      fij[by][bx] = true;
    }

    auto rx = w2 - mx, ry = h2 - my;
    if (fij[my][mx] || fij[my][rx] || fij[ry][mx] || fij[ry][rx])
      writeln("Hit");
    else
      writeln("Miss");
  }
}
