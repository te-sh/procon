import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), h = rd[0], w = rd[1];
  auto s = new string[](h);
  foreach (i; 0..h) s[i] = readln.chomp;

  auto uc = new int[][](h, w), uw = new int[][](h, w);
  foreach (i; 0..h)
    foreach (j; 0..w) {
      uc[i][j] = s[i][j] == 'c';
      uw[i][j] = s[i][j] == 'w';
    }

  auto ch = uc.toCs, wh = uw.toCs;
  auto cv = uc.transposed.map!(a => a.array).array.toCs;
  auto wv = uw.transposed.map!(a => a.array).array.toCs;

  auto ucwr = new int[][](h, w), ucwl = new int[][](h, w);
  foreach (i; 0..h)
    foreach (j; 0..w)
      if (s[i][j] == 'c') {
        ucwr[i][j] = wh[i][j..$];
        ucwl[i][j] = wh[i][0..j];
      }
  auto cwr = ucwr.toCs, cwl = ucwl.toCs;

  auto ucwb = new int[][](w, h), ucwu = new int[][](w, h);
  foreach (i; 0..w)
    foreach (j; 0..h)
      if (s[j][i] == 'c') {
        ucwb[i][j] = wv[i][j..$];
        ucwu[i][j] = wv[i][0..j];
      }
  auto cwb = ucwb.toCs, cwu = ucwu.toCs;

  auto ucwwr = new int[][](h, w), ucwwl = new int[][](h, w);
  foreach (i; 0..h)
    foreach (j; 0..w)
      if (s[i][j] == 'c') {
        ucwwr[i][j] = wh[i][j..$] * (wh[i][j..$] - 1) / 2;
        ucwwl[i][j] = wh[i][0..j] * (wh[i][0..j] - 1) / 2;
      }
  auto cwwr = ucwwr.toCs, cwwl = ucwwl.toCs;
  
  auto ucwwb = new int[][](w, h), ucwwu = new int[][](w, h);
  foreach (i; 0..w)
    foreach (j; 0..h)
      if (s[j][i] == 'c') {
        ucwwb[i][j] = wv[i][j..$] * (wv[i][j..$] - 1) / 2;
        ucwwu[i][j] = wv[i][0..j] * (wv[i][0..j] - 1) / 2;
      }
  auto cwwb = ucwwb.toCs, cwwu = ucwwu.toCs;

  auto q = readln.chomp.to!int;
  foreach (_; 0..q) {
    auto rd2 = readln.splitter;
    auto a = rd2.front.to!int-1; rd2.popFront();
    auto b = rd2.front.to!int-1; rd2.popFront();
    auto c = rd2.front.to!int;   rd2.popFront();
    auto d = rd2.front.to!int;

    auto r = 0L;

    foreach (i; a..c) {
      auto ww1 = wh[i][d..$] * (wh[i][d..$] - 1) / 2;
      auto cw1 = cwr[i][b..$] - cwr[i][d..$] - ch[i][b..d] * wh[i][d..$];
      auto cww1 = cwwr[i][b..$] - cwwr[i][d..$] - ch[i][b..d] * ww1 - cw1 * wh[i][d..$];

      auto ww2 = wh[i][0..b] * (wh[i][0..b] - 1) / 2;
      auto cw2 = cwl[i][0..d] - cwl[i][0..b] - ch[i][b..d] * wh[i][0..b];
      auto cww2 = cwwl[i][0..d] - cwwl[i][0..b] - ch[i][b..d] * ww2 - cw2 * wh[i][0..b];

      r += cww1 + cww2;
    }

    foreach (i; b..d) {
      auto ww1 = wv[i][c..$] * (wv[i][c..$] - 1) / 2;
      auto cw1 = cwb[i][a..$] - cwb[i][c..$] - cv[i][a..c] * wv[i][c..$];
      auto cww1 = cwwb[i][a..$] - cwwb[i][c..$] - cv[i][a..c] * ww1 - cw1 * wv[i][c..$];

      auto ww2 = wv[i][0..a] * (wv[i][0..a] - 1) / 2;
      auto cw2 = cwu[i][0..c] - cwu[i][0..a] - cv[i][a..c] * wv[i][0..a];
      auto cww2 = cwwu[i][0..c] - cwwu[i][0..a] - cv[i][a..c] * ww2 - cw2 * wv[i][0..a];

      r += cww1 + cww2;
    }

    writeln(r);
  }
}

auto toCs(T)(T[][] a)
{
  auto r = new Cs!T[](a.length);
  foreach (i, ai; a) r[i] = Cs!T(ai);
  return r;
}

struct Cs(T)
{
  T[] c;

  this(T[] a)
  {
    c = new T[](a.length+1);
    foreach (i, ai; a) c[i+1] = c[i] + ai;
  }

  pure auto opSlice(size_t l, size_t r)
  {
    return c[r] - c[l];
  }

  pure auto opDollar()
  {
    return c.length-1;
  }
}
