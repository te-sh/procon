import std.algorithm, std.conv, std.range, std.stdio, std.string;

version(unittest) {} else
void main()
{
  auto s = readln.chomp;
  int n = s.length.to!int, n5 = n / 5;

  auto dp = new int[][][][][](n+1, n5+1, n5+1, n5+1, n5+1);
  foreach (i; 0..n+1)
    foreach (k; 0..n5+1)
      foreach (ku; 0..n5+1)
        foreach (kur; 0..n5+1)
          dp[i][k][ku][kur][] = -1;

  int calc(int i, int k, int ku, int kur, int kuro)
  {
    if (dp[i][k][ku][kur][kuro] >= 0) return dp[i][k][ku][kur][kuro];
    if (i >= n) return 0;

    int r;

    int calcN()     { return calc(i+1, k, ku, kur, kuro); }
    int calcK()     { return calc(i+1, min(k+1, n5), ku, kur, kuro); }
    int calcKu()    { return k    > 0 ? calc(i+1, k-1, min(ku+1, n5), kur, kuro) : calcN(); }
    int calcKur()   { return ku   > 0 ? calc(i+1, k, ku-1, min(kur+1, n5), kuro) : calcN(); }
    int calcKuro()  { return kur  > 0 ? calc(i+1, k, ku, kur-1, min(kuro+1, n5)) : calcN(); }
    int calcKuroi() { return kuro > 0 ? calc(i+1, k, ku, kur, kuro-1) + 1        : calcN(); }

    switch (s[i]) {
    case 'K': r = calcK(); break;
    case 'U': r = calcKu(); break;
    case 'R': r = calcKur(); break;
    case 'O': r = calcKuro(); break;
    case 'I': r = calcKuroi(); break;
    case '?': r = max(calcK(), calcKu(), calcKur(), calcKuro(), calcKuroi()); break;
    default:  r = calcN(); break;
    }

    return dp[i][k][ku][kur][kuro] = r;
  }

  writeln(calc(0, 0, 0, 0, 0));
}
