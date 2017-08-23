import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), t = rd[0], a = rd[1], b = rd[2];

  if (a == 0 && b == 0) {
    if (t == 1) {
      writeln("NO");
    } else {
      writeln("YES");
      if (t % 2 == 1) {
        writeln("^>");
        writeln("v");
        writeln("<");
        t -= 3;
      }

      foreach (_; 0..t/2) {
        writeln("^");
        writeln("v");
      }
    }
  } else {
    auto ru = min(a, b), u = a - ru, r = b - ru;
    auto m = t - (ru + r + u);
    if (m < 0) {
      writeln("NO");
    } else {
      writeln("YES");
      foreach (_; 0..m/2) {
        writeln("^");
        writeln("v");
      }
      if (m % 2 == 1) {
        if (ru > 0) {
          writeln(">");
          writeln("^");
          --ru;
        } else if (r > 0) {
          writeln("^>");
          writeln("v");
          --r;
        } else {
          writeln("^>");
          writeln("<");
          --u;
        }
      }
      foreach (_; 0..ru)
        writeln("^>");
      foreach (_; 0..u)
        writeln("^");
      foreach (_; 0..r)
        writeln(">");
    }
  }
}
