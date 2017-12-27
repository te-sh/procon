import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1], c = rd[2];
  auto ac = readln.split.to!(real[]);
  auto bc = readln.split.to!(real[]);

  auto av = ac.sum / a;

  auto dp1 = new real[][](b+1, b+1);
  dp1[0][0] = 1; dp1[0][1..$] = 0;
  foreach (i; 0..b)
    foreach (j; 0..b+1) {
      dp1[i+1][j] = dp1[i][j];
      if (j > 0) dp1[i+1][j] += bc[i]*dp1[i][j-1];
    }

  auto pt = pascalTriangle!real(b);

  auto bv = new real[](b+1);
  foreach (i; 0..b+1) bv[i] = dp1[b][i]/pt[b][i];

  auto e = new real[][](a+1, b+1);
  foreach (i; 0..a+1) e[i][] = 0;

  foreach (i; 0..a+1)
    foreach (j; 0..b+1) {
      if (i > 0) e[i][j] += (e[i-1][j] + bv[b-j]) * i/(i+j+c);
      if (j > 0) e[i][j] += e[i][j-1] * j/(i+j+c);
    }

  writefln("%.7g", av*e[a][b]);
}

pure T[][] pascalTriangle(T)(size_t n)
{
  auto t = new T[][](n + 1);
  t[0] = new T[](1);
  t[0][0] = 1;
  foreach (i; 1..n+1) {
    t[i] = new T[](i + 1);
    t[i][0] = t[i][$-1] = 1;
    foreach (j; 1..i)
      t[i][j] = t[i - 1][j - 1] + t[i - 1][j];
  }
  return t;
}
