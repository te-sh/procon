import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto si = n.iota.map!(_ => readln.chomp.to!int).array;
  auto m = readln.chomp.to!size_t;
  auto cij = new int[][](n, n);
  foreach (_; m.iota) {
    auto rd = readln.split, a = rd[0].to!size_t, b = rd[1].to!size_t, c = rd[2].to!int;
    cij[a][b] = c;
    cij[b][a] = c;
  }

  auto dij = cij.warshalFloyd;

  auto r = int.max;
  foreach (i; 1..n-1)
    foreach (j; 1..n-1)
      if (i != j) {
        auto c1 = dij[0][i];
        auto c2 = dij[i][j];
        auto c3 = dij[j][n-1];
        if (c1 && c2 && c3)
          r = min(r, c1 + c2 + c3 + si[i] + si[j]);
      }

  writeln(r);
}

T[][] warshalFloyd(T)(T[][] a)
{
  auto n = a.length;

  auto b = new T[][](n);
  foreach (i; 0..n) b[i] = a[i].dup;

  foreach (k; 0..n)
    foreach (i; 0..n)
      foreach (j; 0..n)
        if ((i == k || b[i][k]) && (k == j || b[k][j])) {
          auto s = b[i][k] + b[k][j];
          if (i == j || b[i][j])
            b[i][j] = min(b[i][j], s);
          else
            b[i][j] = s;
        }

  return b;
}
