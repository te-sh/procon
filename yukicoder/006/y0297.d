import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.ascii;

version(unittest) {} else
void main()
{
  auto n = readln.chomp.to!size_t;
  auto ci = readln.split;

  auto di = ci.filter!(c => c[0].isDigit).array; di.sort!"a > b";
  auto cp = ci.count!(c => c == "+").to!int;
  auto cm = ci.count!(c => c == "-").to!int;

  writeln(calcMax(di, cp, cm), " ", calcMin(di, cp, cm));
}

auto calcMax(string[] di, int cp, int cm)
{
  auto i = di.length.to!int - cp - cm;
  return di[0..i].toLong + di[i..i+cp].to!(long[]).sum - di[i+cp..$].to!(long[]).sum;
}

auto calcMin(string[] di, int cp, int cm)
{
  if (cm == 0) {
    auto m = cp+1, ri = new string[](m);
    di.reverse();
    foreach (i, d; di) ri[i % m] ~= d;
    return ri.to!(long[]).sum;
  } else {
    auto i = di.length.to!int - cp - cm;
    return - di[0..i].toLong - di[i..i+cm-1].to!(long[]).sum + di[i+cm-1..$].to!(long[]).sum;
  }
}

auto toLong(string[] s)
{
  auto r = 0L;
  foreach (c; s) r = r * 10 + c.to!long;
  return r;
}
