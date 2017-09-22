import std.algorithm, std.conv, std.range, std.stdio, std.string;

// path: arc069_b

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto s = readln.chomp;

  auto isValid(bool[] sw)
  {
    foreach (i; 2..n)
      sw[i] = sw[i-1] ^ (s[i-1] != 'o') ^ sw[i-2];

    return ((sw[$-1] ^ (s[$-1] != 'o') ^ sw[$-2]) == sw[0] &&
            (sw[0]   ^ (s[0]   != 'o') ^ sw[$-1]) == sw[1]);
  }

  foreach (sw1; [false, true])
    foreach (sw2; [false, true]) {
      auto sw = new bool[](n);
      sw[0] = sw1;
      sw[1] = sw2;
      if (isValid(sw)) {
        foreach (swi; sw) write(swi ? 'W' : 'S');
        writeln;
        return;
      }
    }

  writeln(-1);
}
