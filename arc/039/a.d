import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto rd = readln.split.to!(int[]), a = rd[0], b = rd[1];

  auto a2 = a;
  if (a/100 < 9)
    a2 += (9-a/100)*100;
  else if (a%100/10 < 9)
    a2 += (9-a%100/10)*10;
  else
    a2 += 9-a%10;

  auto b2 = b;
  if (b/100 > 1)
    b2 -= (b/100-1)*100;
  else if (b%100/10 > 0)
    b2 -= b%100/10*10;
  else
    b2 -= b%10;

  writeln(max(a2-b, a-b2));
}
