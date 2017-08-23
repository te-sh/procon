import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

const eos = '|';

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto si = n.iota.map!(_ => readln.chomp ~ eos).array;

  auto h = si.heapify!"a > b";
  auto r = "";
  for (;;) {
    auto s = h.front;
    if (s[0] == eos) break;
    r ~= s[0];
    h.replaceFront(s[1..$]);
  }

  writeln(r);
}
