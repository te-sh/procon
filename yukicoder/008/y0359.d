import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;
  foreach (_; 0..t) calc();
}

auto calc()
{
  auto l = readln.chomp.to!int;
  auto a = 3.iota.map!(_ => readln.split.to!(int[])).array;

  int[] ex, ey, b = [0, l/2, (l+1)/2, l];
  foreach (i; 0..3)
    foreach (j; 0..3)
      if (a[i][j] == 0) {
        ex ~= j;
        ey ~= i;
      } else {
        b ~= [a[i][j], l - a[i][j]];
      }

  b = b.filter!(bi => bi >= 0 && bi <= l).array.sort().uniq.array;

  auto r = 0, bl = b.length;
  foreach (i; 0..bl) {
    if (i > 0 && b[i] - b[i-1] > 1) {
      a[ey[0]][ex[0]] = b[i] - 1;
      a[ey[1]][ex[1]] = l - b[i] + 1;
      if (isKadomatsuMatrix(a)) r += b[i] - b[i-1] - 1;
    }
    if (i > 0 && i < bl-1) {
      a[ey[0]][ex[0]] = b[i];
      a[ey[1]][ex[1]] = l - b[i];
      if (isKadomatsuMatrix(a)) ++r;
    }
  }

  writeln(r);
}

const ps = [[[0,0],[0,1],[0,2]],[[1,0],[1,1],[1,2]],[[2,0],[2,1],[2,2]],
            [[0,0],[1,0],[2,0]],[[0,1],[1,1],[2,1]],[[0,2],[1,2],[2,2]],
            [[0,0],[1,1],[2,2]],[[2,0],[1,1],[0,2]]];

auto isKadomatsuMatrix(int[][] a)
{
  foreach (p; ps) {
    auto v1 = a[p[0][0]][p[0][1]],
         v2 = a[p[1][0]][p[1][1]],
         v3 = a[p[2][0]][p[2][1]];
    if (!isKadomatsu(v1, v2, v3)) return false;
  }
  return true;
}

auto isKadomatsu(int a, int b, int c)
{
  return a != b && b != c && c != a && (a > b && c > b || a < b && c < b);
}
