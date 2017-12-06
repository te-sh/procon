import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), n = rd[0], k = rd[1], q = rd[2];

  struct Query { char a; int b, c; }
  auto queries = new Query[](q);
  foreach (i; 0..q) {
    auto rd2 = readln.splitter;
    auto a = rd2.front[0]; rd2.popFront();
    auto b = rd2.front.to!int-1; rd2.popFront();
    auto c = rd2.front.to!int-1;
    queries[i] = Query(a, b, c);
  }

  auto cnt = new long[](k), vr = new bool[](n), vc = new bool[](n);
  auto nr = n, nc = n;
  foreach_reverse (query; queries) {
    switch (query.a) {
    case 'R':
      if (vr[query.b]) continue;
      vr[query.b] = true;
      cnt[query.c] += nc;
      --nr;
      break;
    case 'C':
      if (vc[query.b]) continue;
      vc[query.b] = true;
      cnt[query.c] += nr;
      --nc;
      break;
    default:
      assert(0);
    }
  }

  cnt[0] = n.to!long ^^ 2 - cnt[1..$].sum;
  cnt.each!writeln;
}
