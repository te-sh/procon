import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto d = readln.chomp.to!int;
  auto s1 = readln.chomp, s2 = readln.chomp, s = s1 ~ s2;

  auto r = s.group.filter!"a[0] == 'o'".map!"a[1]".maxElement;
  foreach (cd; 1..d+1) {
    auto wd = 'x'.repeat.take(cd).array, hd = 'o'.repeat.take(cd).array;
    auto ts = wd ~ s ~ wd;
    foreach (i; 0..ts.length-cd+1) {
      if (ts[i..i+cd] == wd) {
        auto t = ts.dup;
        t[i..i+cd] = hd;
        r = max(r, t.group.filter!"a[0] == 'o'".map!"a[1]".maxElement);
      }
    }
  }

  writeln(r);
}
