import std.conv;

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

pure T[][] starling2(T)(size_t n)
{
  auto t = new T[][](n + 1);
  t[0] = new T[](1);
  t[0][0] = 1;
  foreach (i; 1..n+1) {
    t[i] = new T[](i + 1);
    t[i][0] = 0;
    t[i][$-1] = 1;
    foreach (j; 1..i)
      t[i][j] = t[i - 1][j - 1] + j.to!T * t[i - 1][j];
  }
  return t;
}

unittest
{
  auto t1 = pascalTriangle!int(10);
  assert(t1[0][0] == 1);
  assert(t1[1][0] == 1);
  assert(t1[1][1] == 1);
  assert(t1[2][1] == 2);
  assert(t1[5][3] == 10);
  assert(t1[10][5] == 252);

  import factor_ring;
  alias mint = FactorRing!10;
  auto t2 = pascalTriangle!mint(10);
  assert(t2[0][0] == 1);
  assert(t2[1][0] == 1);
  assert(t2[1][1] == 1);
  assert(t2[2][1] == 2);
  assert(t2[5][3] == 0);
  assert(t2[10][5] == 2);
}

unittest
{
  auto t1 = starling2!int(7);
  assert(t1[0][0] == 1);
  assert(t1[1][0] == 0);
  assert(t1[1][1] == 1);
  assert(t1[2][1] == 1);
  assert(t1[5][3] == 25);
  assert(t1[7][5] == 140);

  import factor_ring;
  alias mint = FactorRing!10;
  auto t2 = starling2!mint(7);
  assert(t2[0][0] == 1);
  assert(t2[1][0] == 0);
  assert(t2[1][1] == 1);
  assert(t2[2][1] == 1);
  assert(t2[5][3] == 5);
  assert(t2[7][5] == 0);
}
