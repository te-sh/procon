import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto t = readln.chomp.to!size_t;

  foreach (_; t.iota) {
    auto s = readln.chomp;

    auto mi = int.max;
    foreach (i; 0..s.length-10) {
      auto hg = hammingDistance(s[i..i+4], "good");
      foreach (j; i+4..s.length-6) {
        auto hp = hammingDistance(s[j..j+7], "problem");
        mi = min(mi, hg + hp);
      }
    }

    writeln(mi);
  }
}

auto hammingDistance(string a, string b)
{
  return zip(a, b).count!"a[0] != a[1]";
}
