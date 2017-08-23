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
    import std.string;
    __gmpz_init(&z);
    __gmpz_set_str(&z, s.toStringz, base);
  }

  auto toString(int base = 10)
  {
    import std.string;
    auto sz = __gmpz_sizeinbase(&z, base);
    auto buf = new char[](sz + 2);
    __gmpz_get_str(buf.ptr, base, &z);
    return buf.ptr.fromStringz;
  }

  auto opCmp(GmpInt v)
  {
    return __gmpz_cmp(&z, &v.z);
  }

  auto opBinary(string op)(GmpInt v)
    if (op == "+" || op == "-" || op == "*" || op == "/" || op == "%")
  {
    auto r = GmpInt(0);
    static if (op == "+") __gmpz_add(&r.z, &z, &v.z);
    else   if (op == "-") __gmpz_sub(&r.z, &z, &v.z);
    else   if (op == "*") __gmpz_mul(&r.z, &z, &v.z);
    else   if (op == "/") __gmpz_tdiv_q(&r.z, &z, &v.z);
    else   if (op == "%") __gmpz_mod(&r.z, &z, &v.z);
    return r;
  }

  auto opOpAssign(string op)(GmpInt v)
    if (op == "+" || op == "-" || op == "*" || op == "/" || op == "%")
  {
    static if (op == "+") __gmpz_add(&z, &z, &v.z);
    else   if (op == "-") __gmpz_sub(&z, &z, &v.z);
    else   if (op == "*") __gmpz_mul(&z, &z, &v.z);
    else   if (op == "/") __gmpz_tdiv_q(&z, &z, &v.z);
    else   if (op == "%") __gmpz_mod(&z, &z, &v.z);
    return this;
  }

  size_t popcnt()
  {
    return __gmpz_popcount(&z);
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

  int __gmpz_cmp(mpz_srcptr, mpz_srcptr);

  void __gmpz_add(mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_sub(mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_mul(mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_tdiv_q(mpz_ptr, mpz_srcptr, mpz_srcptr);
  void __gmpz_mod(mpz_ptr, mpz_srcptr, mpz_srcptr);

  size_t __gmpz_popcount(mpz_srcptr);

  int __gmpz_probab_prime_p(mpz_ptr, int reps);

  size_t __gmpz_sizeinbase(mpz_srcptr, int);
  char *__gmpz_get_str(char*, int, mpz_srcptr);
}

pragma(lib, "gmp");

unittest
{
  import std.conv, std.random;

  foreach (_; 0..1000) {
    auto a1 = uniform(-1000, 1000), b1 = GmpInt(a1);
    auto a2 = uniform(-1000, 1000), b2 = GmpInt(a2);
    assert(b1.toString == a1.to!string);
    assert(GmpInt(a1.to!string).toString == a1.to!string);
    assert((a1 > a2) == (b1 > b2));
    assert((a1 < a2) == (b1 < b2));
    assert((a1 == a2) == (b1 == b2));
    assert((b1 + b2).toString == (a1 + a2).to!string);
    assert((b1 - b2).toString == (a1 - a2).to!string);
    assert((b1 * b2).toString == (a1 * a2).to!string);
    if (a2 != 0)
      assert((b1 / b2).toString == (a1 / a2).to!string);

    auto a3 = uniform(-1000, 1000), b3 = GmpInt(a3);
    auto a4 = uniform(-1000, 1000), b4 = GmpInt(a4);
    auto a5 = uniform(-1000, 1000), b5 = GmpInt(a5);
    auto a6 = uniform(-1000, 1000), b6 = GmpInt(a6);
    b3 += b1; b4 -= b1; b5 *= b1;
    assert(b3.toString == (a3 + a1).to!string);
    assert(b4.toString == (a4 - a1).to!string);
    assert(b5.toString == (a5 * a1).to!string);

    if (a1 != 0) {
      b6 /= b1;
      assert(b6.toString == (a6 / a1).to!string);
    }

    auto c1 = uniform(1, 1000), d1 = GmpInt(c1);
    auto c2 = uniform(1, 1000), d2 = GmpInt(c2);
    assert((d1 % d2).toString == (d1 % d2).to!string);

    auto c3 = uniform(1, 1000), d3 = GmpInt(c3);
    d3 %= d1;
    assert(d3.toString == (c3 % c1).to!string);
  }
}
