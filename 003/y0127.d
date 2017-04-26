import std.algorithm, std.conv, std.range, std.stdio, std.string;

void main()
{
  auto n = readln.chomp.to!size_t;
  auto ai = readln.split.to!(int[]);

  auto calc = new Calc(n, ai);

  auto r = 0;
  foreach (i; 0..n) {
    r = max(r, calc.calcA(i, n-1));
    r = max(r, calc.calcB(i, 0));
  }

  writeln(r);
}

class Calc
{
  size_t n;
  int[] ai;
  int[][] dpa, dpb;

  this(size_t n, int[] ai)
  {
    this.n = n;
    this.ai = ai;
    dpa = new int[][](n, n);
    dpb = new int[][](n, n);
  }

  int calcA(size_t i, size_t j)
  {
    if (i == j) return 1;
    if (dpa[i][j]) return dpa[i][j];

    auto r = calcA(i, j-1);
    if (ai[i] < ai[j])
      r = max(r, calcB(j, i+1) + 1);

    return dpa[i][j] = r;
  }

  int calcB(size_t i, size_t j)
  {
    if (i == j) return 1;
    if (dpb[i][j]) return dpb[i][j];

    auto r = calcB(i, j+1);
    if (ai[i] < ai[j])
      r = max(r, calcA(j, i-1) + 1);

    return dpb[i][j] = r;
  }
}
