import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto a = readln.split.to!(int[]);

  auto r = new int[](n);
  size_t[int] hash;

  foreach (i, ai; a) {
    if (ai in hash) r[hash[ai]] = 0;
    r[i] = ai;
    hash[ai] = i;
  }

  auto b = new int[](n);
  auto rbt = redBlackTree!("a > b", int)();
  foreach (i, ai; a) {
    rbt.insert(ai);
    b[i] = rbt.front;
    if (r[i] > 0) rbt.removeKey(r[i]);
  }

  foreach (i, bi; b) {
    write(bi);
    if (i < n-1) write(" ");
  }
  writeln;
}
