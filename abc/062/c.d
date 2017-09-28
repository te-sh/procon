import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc074_a

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(long[]), h = rd[0], w = rd[1];
  writeln(min(calc(h, w), calc(w, h)));
}

auto calc(long h, long w)
{
  auto calc2(long h, long w, long w1)
  {
    auto wr = w-w1;

    auto w2 = wr/2, w3 = wr-w2;
    auto s1 = [w1*h, w2*h, w3*h];
    s1.sort();

    auto h1 = h/2, h2 = h-h1;
    auto s2 = [w1*h, wr*h1, wr*h2];
    s2.sort();

    return min(s1[2]-s1[0], s2[2]-s2[0]);
  }

  return min(calc2(h, w, w/3), calc2(h, w, (w+2)/3));
}
