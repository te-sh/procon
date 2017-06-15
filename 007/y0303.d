import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto l = readln.chomp.to!int;

  if (l == 1) {
    writeln(1);
    writeln(1);
  } else if (l == 2) {
    writeln(3);
    writeln("INF");
  } else {
    writeln(l);
    auto r = calc(l);
    if (l % 2 == 0) {
      auto s = calc(l/2);
      r -= s * s;
    }
    writeln(r.toString);
  }
}

auto calc(int l)
{
  auto o = GmpInt(1), z = GmpInt(0);
  auto a = [[o,o],[o,z]];
  auto im = [[o,z],[z,o]];

  auto b = repeatedSquare!(GmpInt[][], matMul)(a, l-2, im);
  return b[0][0] + b[0][1];
}

T[][] matMul(T)(T[][] a, T[][] b)
{
  auto l = b.length, m = a.length, n = b[0].length;
  auto c = new T[][](m, n);
  foreach (i; 0..m)
    foreach (j; 0..n)
      foreach (k; 0..l)
        c[i][j] += a[i][k] * b[k][j];
  return c;
}

T[] matMulVec(T)(T[][] a, T[] b)
{
  auto l = b.length, m = a.length;
  auto c = new T[](m);
  foreach (i; 0..m)
    foreach (j; 0..l)
      c[i] += a[i][j] * b[j];
  return c;
}

T repeatedSquare(T, alias pred = "a * b", U)(T a, U n, T init)
{
  import std.functional;
  alias predFun = binaryFun!pred;

  if (n == 0) return init;

  static buf = new T[](32);
  static bufFilled = 0;

  if (bufFilled == 0)
    buf[bufFilled++] = a;

  auto r = init, i = 0;
  while (n > 0) {
    if ((n & 1) == 1)
      r = predFun(r, buf[i]);
    if (++i == bufFilled)
      buf[bufFilled++] = predFun(buf[i-1], buf[i-1]);
    n >>= 1;
  }

  return r;
}

struct GmpInt
{
  __mpz_struct z;

  this(long v)
  {
    __gmpz_init(&z);
    __gmpz_set_si(&z, v);
  }

  auto toString()
  {
    auto sz = __gmpz_sizeinbase(&z, 10);
    auto str = new string(sz + 1);
    __gmpz_get_str(cast(char*)str.ptr, 10, &z);
    return str.ptr.fromStringz;
  }

  auto opBinary(string op)(GmpInt v)
    if (op == "+" || op == "-" || op == "*")
  {
    auto r = GmpInt(0);
    static if (op == "+") __gmpz_add(&r.z, &z, &v.z);
    else   if (op == "-") __gmpz_sub(&r.z, &z, &v.z);
    else   if (op == "*") __gmpz_mul(&r.z, &z, &v.z);
    return r;
  }

  auto opOpAssign(string op)(GmpInt v)
    if (op == "+" || op == "-" || op == "*")
  {
    static if (op == "+") __gmpz_add(&z, &z, &v.z);
    else   if (op == "-") __gmpz_sub(&z, &z, &v.z);
    else   if (op == "*") __gmpz_mul(&z, &z, &v.z);
    return this;
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

  size_t __gmpz_sizeinbase(mpz_srcptr, int);
  char *__gmpz_get_str(char*, int, mpz_srcptr);
}

pragma(lib, "gmp");
