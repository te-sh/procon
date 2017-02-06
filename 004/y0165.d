import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.typecons;  // Tuple, Nullable, BigFlags

version(unittest) {} else
void main()
{
  auto rd1 = readln.split, n = rd1[0].to!size_t, b = rd1[1].to!int;
  auto pi = n.iota.map!(_ => readln.split.to!(int[])).map!(rd2 => point(rd2[0], rd2[1], rd2[2])).array;

  auto rd3 = compress(pi), cpi = rd3[0], nx = rd3[1], ny = rd3[2];

  auto npi = new int[](ny), pti = new int[](ny);
  auto cnpi = new int[](ny + 1), cpti = new int[](ny + 1);

  auto r = 0;
  foreach (x0; 0..nx)
    foreach (x1; x0..nx) {
      npi[] = 0; pti[] = 0;
      foreach (p; cpi)
        if (p.x >= x0 && p.x <= x1) {
          ++npi[p.y];
          pti[p.y] += p.pt;
        }

      cnpi[0] = cpti[0] = 0;
      foreach (i; ny.iota) {
        cnpi[i + 1] = npi[i] + cnpi[i];
        cpti[i + 1] = pti[i] + cpti[i];
      }

      auto y0 = 0, y1 = 0;
      while (y1 < ny) {
        auto pt = cpti[y1 + 1] - cpti[y0];
        if (pt <= b) {
          auto np = cnpi[y1 + 1] - cnpi[y0];
          r = max(r, np);
          ++y1;
        } else {
          ++y0;
        }
      }
    }

  writeln(r);
}

auto compress(point[] pi)
{
  auto xi = pi.map!"a.x".array, yi = pi.map!"a.y".array;
  auto cxi = xi.sort().uniq.array, cyi = yi.sort().uniq.array;

  int[int] mx, my;
  foreach (int i, x; cxi) mx[x] = i;
  foreach (int i, y; cyi) my[y] = i;

  foreach (ref p; pi) {
    p.x = mx[p.x];
    p.y = my[p.y];
  }

  return tuple(pi, cxi.length, cyi.length);
}

struct point {
  int x, y, pt;
}
