import std.algorithm, std.conv, std.range, std.stdio, std.string;

const l = ['a', 'c', 'b'];
const r = ['c', 'a', 'b'];

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = readln.chomp;

  auto check()
  {
    if (n % 2 == 0) return -1;

    auto c = ((n-1)/2).to!int;
    if (s[c] != 'b') return -1;

    foreach (i; 0..c) {
      if (s[c-i-1] != l[i%3] || s[c+i+1] != r[i%3])
        return -1;
    }

    return c;
  }

  writeln(check);
}
