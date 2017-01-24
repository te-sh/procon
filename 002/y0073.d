import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap
import std.typecons;  // Tuple, Nullable, BigFlags
import std.math;      // math functions
import std.numeric;   // gcd
import std.bigint;    // BigInt
import std.random;    // random
import std.bitmanip;  // BitArray
import core.bitop;    // bit operation
import std.regex;     // RegEx
import std.uni;       // unicode

version(unittest) {} else
void main()
{
  auto ci = 26.iota.map!(_ => readln.chomp.to!long).array;

  auto r = ci['h' - 'a'] * ci['e' - 'a'] * ci['w' - 'a'] * ci['r' - 'a'] * ci['d' - 'a'];
  r *= calcO(ci['o' - 'a']) * calcL(ci['l' - 'a']);

  writeln(r);
}

auto calcO(long c)
{
  auto r = 0L;
  foreach (x; 1..c)
    r = max(r, x * (c - x));
  return r;
}

auto calcL(long c)
{
  auto r = 0L;
  foreach (x; 2..c)
    r = max(r, x * (x - 1) / 2 * (c - x));
  return r;
}
