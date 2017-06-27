import std.algorithm, std.conv, std.range, std.stdio, std.string;
import std.container; // SList, DList, BinaryHeap

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  if (s.length <= 8) {
    auto n = s.to!int;
    if (n < 100)
      calc1(n).writeln;
    else
      calc2(n).writeln;
  } else {
    calc3(s).writeln;
  }
}

const primes100 = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97];

auto calc1(int n)
{
  foreach (w; 3..n) {
    auto q = DList!int(1), v = new bool[](n);
    v[1] = true;

    while (!q.empty) {
      auto p = q.front; q.removeFront();

      int[] c;
      if (p % w > 1 && p-1 > 0) c ~= p-1;
      if (p % w != 0 && p+1 <= n) c ~= p+1;
      if (p-w > 0) c ~= p-w;
      if (p+w <= n) c ~= p+w;

      foreach (ci; c) {
        if (ci == n) return w;
        if (!v[ci] && !primes100.canFind(ci)) {
          v[ci] = true;
          q.insertBack(ci);
        }
      }
    }
  }
  assert(0);
}

auto calc2(int n)
{
  if (n % 8 != 1) return 8;
  n -= 8;

  auto m = n.nsqrt;
  foreach (i; 2..m+1)
    if (n % i == 0) return 8;

  return 14;
}

auto calc3(string s)
{
  auto n = GmpInt(s);

  if ((n % GmpInt(8)).toLong != 1) return 8;
  n -= GmpInt(8);

  if (n.probabPrime(10))
    return 14;
  else
    return 8;
}

pure T nsqrt(T)(T n)
{
  import std.algorithm, std.conv, std.range, core.bitop;
  if (n <= 1) return n;
  T m = 1 << (n.bsr / 2 + 1);
  return iota(1, m).map!"a * a".assumeSorted!"a <= b".lowerBound(n).length.to!T;
}

struct GmpInt
{
  __mpz_struct z;

  this(long v)
  {
    __gmpz_init(&z);
    __gmpz_set_si(&z, v);
  }

  this(string s, int base = 10)
  {
    __gmpz_init(&z);
    __gmpz_set_str(&z, s.toStringz, base);
  }

  auto toLong()
  {
    return __gmpz_get_si(&z);
  }

  auto toString(int base = 10)
  {
    auto sz = __gmpz_sizeinbase(&z, base);
    auto buf = new char[](sz + 2);
    __gmpz_get_str(buf.ptr, base, &z);
    return buf.ptr.fromStringz;
  }

  auto opBinary(string op)(GmpInt v)
    if (op == "+" || op == "-" || op == "*" || op == "%")
  {
    auto r = GmpInt(0);
    static if (op == "+") __gmpz_add(&r.z, &z, &v.z);
    else   if (op == "-") __gmpz_sub(&r.z, &z, &v.z);
    else   if (op == "*") __gmpz_mul(&r.z, &z, &v.z);
    else   if (op == "%") __gmpz_mod(&r.z, &z, &v.z);
    return r;
  }

  auto opOpAssign(string op)(GmpInt v)
    if (op == "+" || op == "-" || op == "*" || op == "%")
  {
    static if (op == "+") __gmpz_add(&z, &z, &v.z);
    else   if (op == "-") __gmpz_sub(&z, &z, &v.z);
    else   if (op == "*") __gmpz_mul(&z, &z, &v.z);
    else   if (op == "%") __gmpz_mod(&z, &z, &v.z);
    return this;
  }

  int probabPrime(int reps)
  {
    return __gmpz_probab_prime_p(&z, reps);
  }
}

extern(C) pragma(inline, false)
{
  alias __mp_limb_t = ulong;

  struct __mpz_struct
  {
    int _mp_alloc;
    int _mp_size;
    __mp_limb_t* _mp_d;
  }

  alias mpz_srcptr = const(__mpz_struct)*;
  alias mpz_ptr = __mpz_struct*;

  void __gmpz_init(mpz_ptr);

  void __gmpz_set_si(mpz_ptr, long);
  int __gmpz_set_str(mpz_ptr, const char*, int);

  void __gmpz_add(mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_sub(mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_mul(mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_mod(mpz_ptr, mpz_srcptr, mpz_srcptr);

  int __gmpz_probab_prime_p(mpz_ptr, int reps);

  size_t __gmpz_sizeinbase(mpz_srcptr, int);
  char *__gmpz_get_str(char*, int, mpz_srcptr);
  long __gmpz_get_si(mpz_srcptr);
}

pragma(lib, "gmp");
