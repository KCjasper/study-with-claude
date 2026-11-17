// 示範：學生在引導模式下自己寫完的成品。
// 真實繳交時檔名與 class 名要照課程規定改成 HW02_<學號>_01。
public class TempConvert {
    // 攝氏轉華氏：F = C × 9 / 5 + 32
    static double cToF(double c) {
        return c * 9 / 5 + 32;
    }

    // 華氏轉攝氏：C = (F − 32) × 5 / 9
    static double fToC(double f) {
        return (f - 32) * 5 / 9;
    }

    public static void main(String[] args) {
        System.out.println("攝氏    華氏");
        for (int c = -10; c <= 40; c += 10) {
            System.out.printf("%4d  %6.1f%n", c, cToF(c));
        }
        System.out.printf("98.6°F = %.1f°C%n", fToC(98.6));
    }
}

/* 執行結果（JDK 21）：
攝氏    華氏
 -10    14.0
   0    32.0
  10    50.0
  20    68.0
  30    86.0
  40   104.0
98.6°F = 37.0°C
*/
