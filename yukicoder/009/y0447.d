import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto l = readln.split.to!(int[]);

  class Table
  {
    string name;
    int[] score;
    size_t order;
    int sum;

    this(string name, size_t n)
    {
      this.name = name;
      score = new int[](n);
    }
  }

  Table[string] tbl;
  auto c = new int[](n);

  auto t = readln.chomp.to!size_t;
  foreach (i; 0..t) {
    auto rd = readln.split, name = rd[0], p = cast(size_t)(rd[1][0] - 'A');
    if (name !in tbl) tbl[name] = new Table(name, n);
    auto sc = (50*l[p] + 50*l[p]/(0.8+0.2*(++c[p]))).to!int;
    tbl[name].score[p] = sc;
    tbl[name].sum += sc;
    tbl[name].order = i;
  }

  auto vt = tbl.values.array;
  vt.multiSort!("a.sum > b.sum", "a.order < b.order");
  foreach (i, vti; vt) {
    write(i+1, " ", vti.name, " ");
    foreach (sci; vti.score) write(sci, " ");
    writeln(vti.sum);
  }
}
