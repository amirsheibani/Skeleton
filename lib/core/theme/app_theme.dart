import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framework_base/packages/framework_core/lib/core_framework.dart';
import 'package:skeleton/generated/l10n.dart';


extension OnThemeType on ThemeType{
  get humanReadable{
    switch(this) {
      case ThemeType.dark:
        return S.current.dark;
      case ThemeType.light:
        return S.current.light;
      case ThemeType.system:
        return S.current.light;
    }
  }
}

extension OnAppTheme on ThemeData {
  PalletColor get primary => brightness == Brightness.light
      ? const PalletColor(0xFFD51224, <int, Color>{
          100: Color(0xFFFFFFFF),
          99: Color(0xFFFCEFF0),
          95: Color(0xFFF8DADD),
          90: Color(0xFFF1B2B8),
          80: Color(0xFFE15A66),
          70: Color(0xFFDB3645),
          60: Color(0xFFD51224),
          50: Color(0xFFB40F1E),
          40: Color(0xFF930C18),
          30: Color(0xFF720913),
          20: Color(0xFF51060D),
          10: Color(0xFF300408),
          0: Color(0xFF000000),
        })
      : const PalletColor(0xFFD51224, <int, Color>{
          100: Color(0xFF000000),
          99: Color(0xFF300408),
          95: Color(0xFF51060D),
          90: Color(0xFF720913),
          80: Color(0xFF930C18),
          70: Color(0xFFB40F1E),
          60: Color(0xFFD51224),
          50: Color(0xFFDB3645),
          40: Color(0xFFE15A66),
          30: Color(0xFFF1B2B8),
          20: Color(0xFFF8DADD),
          10: Color(0xFFFCEFF0),
          0: Color(0xFFFFFFFF),
        });

  PalletColor get secondary => brightness == Brightness.light
      ? const PalletColor(0xFF009CDF, <int, Color>{
          100: Color(0xFFFFFFFF),
          99: Color(0xFFEAF7FC),
          95: Color(0xFFD5EFFA),
          90: Color(0xFFABDFF5),
          80: Color(0xFF82CEEF),
          70: Color(0xFF43B6E8),
          60: Color(0xFF009CDF),
          50: Color(0xFF258BB7),
          40: Color(0xFF1C6889),
          30: Color(0xFF12465C),
          20: Color(0xFF09232E),
          10: Color(0xFF051117),
          0: Color(0xFF000000),
        })
      : const PalletColor(0xFF009CDF, <int, Color>{
          100: Color(0xFF000000),
          99: Color(0xFF051117),
          95: Color(0xFF09232E),
          90: Color(0xFF12465C),
          80: Color(0xFF1C6889),
          70: Color(0xFF258BB7),
          60: Color(0xFF009CDF),
          50: Color(0xFF43B6E8),
          40: Color(0xFF82CEEF),
          30: Color(0xFFABDFF5),
          20: Color(0xFFD5EFFA),
          10: Color(0xFFEAF7FC),
          0: Color(0xFFFFFFFF),
        });

  PalletColor get text => brightness == Brightness.light
      ? const PalletColor(0xFF929295, <int, Color>{
          100: Color(0xFFFFFFFF),
          99: Color(0xFFF4F4F4),
          95: Color(0xFFEAEAEA),
          90: Color(0xFFD4D4D5),
          80: Color(0xFFBFBEC0),
          70: Color(0xFFA9A8AA),
          60: Color(0xFF929295),
          50: Color(0xFF7D7D80),
          40: Color(0xFF68686B),
          30: Color(0xFF525256),
          20: Color(0xFF3D3C41),
          10: Color(0xFF27262C),
          0: Color(0xFF000000),
        })
      : const PalletColor(0xFF929295, <int, Color>{
          100: Color(0xFF000000),
          99: Color(0xFF27262C),
          95: Color(0xFF3D3C41),
          90: Color(0xFF525256),
          80: Color(0xFF68686B),
          70: Color(0xFF7D7D80),
          60: Color(0xFF929295),
          50: Color(0xFFA9A8AA),
          40: Color(0xFFBFBEC0),
          30: Color(0xFFD4D4D5),
          20: Color(0xFFEAEAEA),
          10: Color(0xFFF4F4F4),
          0: Color(0xFFFFFFFF),
        });

  PalletColor get sunriseYellow => brightness == Brightness.light
      ? const PalletColor(0xFFffc53d, <int, Color>{
    100:Color(0xFFfffbe6),
    90: Color(0xFFfff1b8),
    80: Color(0xFFffe58f),
    70: Color(0xFFffd666),
    60: Color(0xFFffc53d),
    50: Color(0xFFfaad14),
    40: Color(0xFFd48806),
    30: Color(0xFFad6800),
    20: Color(0xFF874d00),
    10: Color(0xFF613400),
  })
      : const PalletColor(0xFFfaad14, <int, Color>{
    100: Color(0xFF613400),
    90: Color(0xFF874d00),
    80: Color(0xFFad6800),
    70: Color(0xFFd48806),
    60: Color(0xFFfaad14),
    50: Color(0xFFffc53d),
    40: Color(0xFFffd666),
    30: Color(0xFFffe58f),
    20: Color(0xFFfff1b8),
    10: Color(0xFFfffbe6),
  });

  PalletColor get green => brightness == Brightness.light
      ? const PalletColor(0xFF73d13d, <int, Color>{
    100:Color(0xFFf6ffed),
    90: Color(0xFFd9f7be),
    80: Color(0xFFb7eb8f),
    70: Color(0xFF95de64),
    60: Color(0xFF73d13d),
    50: Color(0xFF52c41a),
    40: Color(0xFF389e0d),
    30: Color(0xFF237804),
    20: Color(0xFF135200),
    10: Color(0xFF092b00),
  })
      : const PalletColor(0xFF52c41a, <int, Color>{
    100: Color(0xFF092b00),
    90: Color(0xFF135200),
    80: Color(0xFF237804),
    70: Color(0xFF389e0d),
    60: Color(0xFF52c41a),
    50: Color(0xFF73d13d),
    40: Color(0xFF95de64),
    30: Color(0xFFb7eb8f),
    20: Color(0xFFd9f7be),
    10: Color(0xFFf6ffed),
  });

  PalletColor get base => brightness == Brightness.light
      ? const PalletColor(0xFF525256, <int, Color>{
    100:Color(0xFFFFFFFF),
    99: Color(0xFFFAFAFA),
    95: Color(0xFFF1F1F1),
    30: Color(0xFF525256),
    20: Color(0xFF3D3C41),
    10: Color(0xFF27262C),
    0: Color(0xFF000000),
  })
      : const PalletColor(0xFFD51224, <int, Color>{
    100: Color(0xFF000000),
    99: Color(0xFF27262C),
    95: Color(0xFF3D3C41),
    30: Color(0xFF525256),
    20: Color(0xFFF1F1F1),
    10: Color(0xFFFAFAFA),
    0:Color(0xFFFFFFFF),
  });



  TextTheme _getTextTheme(String? languageCode) {
    if (languageCode == 'fa') {
      String fontFamily = 'IRANSansX';
      return _getDefaultTextTheme(text, fontFamily);
    } else {
      String fontFamily = 'IRANSansX';
      return _getDefaultTextTheme(text, fontFamily);
    }
  }

  ThemeData theme(String? languageCode) {
    return brightness == Brightness.light
        ? copyWith(
            scaffoldBackgroundColor: base.shade100,
            textSelectionTheme: TextSelectionThemeData(
                cursorColor: primary.shade60,
                selectionColor: primary.shade95,
                selectionHandleColor: primary.shade60
            ),
      splashColor: Colors.transparent,
            primaryColor: primary,
            progressIndicatorTheme: progressIndicatorTheme.copyWith(color: primary.shade50, strokeWidth: 2),
            switchTheme: switchTheme.copyWith(
              trackOutlineColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return primary;
                }
                return text.shade90;
              }),
              trackColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                return text.shade90;
              }),
              thumbColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return text.shade99.withAlpha(5);
                }
                return primary.shade100;
              }),
              thumbIcon: const WidgetStatePropertyAll(Icon(Icons.circle, size: 20, color: Colors.transparent,)),
            ),
            radioTheme: radioTheme.copyWith(
              fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return text;
                }
                return primary;
              }),
              overlayColor: WidgetStateColor.resolveWith((states) => text.shade10.withAlpha(10)),
            ),
            checkboxTheme: checkboxTheme.copyWith(
              fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected) && states.contains(WidgetState.disabled)) {
                  return text;
                }
                if (states.contains(WidgetState.selected)) {
                  return primary;
                }
                return Colors.transparent;
              }),
              checkColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                return primary.shade100;
              }),
              side: BorderSide(color: text, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              overlayColor: WidgetStateColor.resolveWith((states) => text.shade10.withAlpha(10)),
            ),
            unselectedWidgetColor: primary,
            snackBarTheme: snackBarTheme.copyWith(
              backgroundColor: secondary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            textTheme: _getTextTheme(languageCode),
            iconTheme: iconTheme.copyWith(color: text, size: 16),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
              scrolledUnderElevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.dark,
            ),
            floatingActionButtonTheme: floatingActionButtonTheme.copyWith(
              backgroundColor: primary,
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(_getTextTheme(languageCode).labelMedium),
                iconColor: WidgetStateProperty.resolveWith<Color>(
                      (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return text.shade70;
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return primary.shade50;
                    }
                    return text.shade10;
                  },
                ),
                elevation: WidgetStateProperty.all(0),
                overlayColor:WidgetStateProperty.all(Colors.transparent) ,
                splashFactory: InkSplash.splashFactory,
                padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
                backgroundColor: WidgetStateProperty.all(primary.shade100),
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                      (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return text.shade70;
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return primary.shade50;
                    }
                    return text.shade10;
                  },
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                side: WidgetStateProperty.resolveWith<BorderSide>(
                  (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return  BorderSide(
                        width: 1.0,
                        color: text.shade90,
                      );
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return  BorderSide(
                        width: 1.0,
                        color: primary.shade50,
                      );
                    }
                    return  BorderSide(
                      width: 1.0,
                      color: text.shade90,
                    );
                  },
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(_getTextTheme(languageCode).labelMedium),
                iconColor: WidgetStateProperty.resolveWith<Color>(
                      (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return text.shade70;
                    }
                    if (states.contains(WidgetState.pressed)) {
                      return text.shade10;
                    }
                    return text.shade10;
                  },
                ),
                elevation: WidgetStateProperty.all(0),
                padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return text.shade99;
                    }
                    return primary.shade100;
                  },
                ),
                overlayColor: WidgetStateProperty.all(text.shade90),
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return text.shade70;
                    }
                    return text.shade10;
                  },
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(

                iconColor: WidgetStateProperty.resolveWith<Color>(
                      (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return text.shade70;
                    }
                    return text.shade100;
                  },
                ),
                textStyle: WidgetStatePropertyAll(_getTextTheme(languageCode).labelMedium),
                elevation: WidgetStateProperty.all(0),
                padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return text.shade99;
                    }
                    return primary.shade60;
                  },
                ),
                overlayColor: WidgetStateProperty.all(
                    primary.shade50
                ),
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (states) {
                    if (states.contains(WidgetState.disabled)) {
                      return text.shade70;
                    }
                    return text.shade100;
                  },
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

              ),
            ),

            bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
              backgroundColor: text.shade90,
              selectedItemColor: sunriseYellow.shade60,
              unselectedItemColor: text.shade60,
              selectedIconTheme: iconTheme.copyWith(color: sunriseYellow.shade60),
              selectedLabelStyle: _getTextTheme(languageCode).labelMedium?.copyWith(color: sunriseYellow.shade60),
              unselectedIconTheme: iconTheme.copyWith(color: text.shade60),
              unselectedLabelStyle: _getTextTheme(languageCode).labelMedium?.copyWith(color: text.shade60),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: secondary,
              surfaceTintColor: secondary,
              headerHeadlineStyle: _getTextTheme(languageCode).titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              todayBackgroundColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return primary;
                  }
                  return Colors.transparent;
                },
              ),
              todayForegroundColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (!states.contains(WidgetState.selected)) {
                    return primary;
                  }
                  return secondary;
                },
              ),
              todayBorder: BorderSide(color: primary),
              weekdayStyle: _getTextTheme(languageCode).labelMedium?.copyWith(color: primary),
              dayBackgroundColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return primary;
                  }
                  return Colors.transparent;
                },
              ),
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return primary;
                  },
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return secondary;
                  },
                ),
                textStyle: WidgetStateProperty.resolveWith(
                  (states) {
                    return _getTextTheme(languageCode).labelMedium;
                  },
                ),
              ),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return primary;
                  },
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return secondary;
                  },
                ),
                textStyle: WidgetStateProperty.resolveWith(
                  (states) {
                    return _getTextTheme(languageCode).labelMedium;
                  },
                ),
              ),
            ),
          )
        : copyWith(
      scaffoldBackgroundColor: base.shade100,
            splashColor: Colors.transparent,
            primaryColor: primary,
            progressIndicatorTheme: progressIndicatorTheme.copyWith(color: primary.shade50, strokeWidth: 2),
            buttonTheme: buttonTheme.copyWith(),
            switchTheme: switchTheme.copyWith(
              trackOutlineColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected)) {
                  return primary;
                }
                return text.shade30;
              }),
              trackColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                return text.shade30;
              }),
              thumbColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return text.shade10.withAlpha(5);
                }
                return primary.shade0;
              }),
              thumbIcon: const WidgetStatePropertyAll(Icon(Icons.circle, size: 20, color: Colors.transparent,)),
            ),
            radioTheme: radioTheme.copyWith(
              fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.disabled)) {
                  return text;
                }
                return primary;
              }),
              overlayColor: WidgetStateColor.resolveWith((states) => text.shade99.withAlpha(10)),
            ),
            checkboxTheme: checkboxTheme.copyWith(
              fillColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                if (states.contains(WidgetState.selected) && states.contains(WidgetState.disabled)) {
                  return text;
                }
                if (states.contains(WidgetState.selected)) {
                  return primary;
                }
                return Colors.transparent;
              }),
              checkColor: WidgetStateColor.resolveWith((Set<WidgetState> states) {
                return primary.shade0;
              }),
              side: BorderSide(color: text, width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              overlayColor: WidgetStateColor.resolveWith((states) => text.shade99.withAlpha(10)),
            ),
            unselectedWidgetColor: primary,
            snackBarTheme: snackBarTheme.copyWith(
              backgroundColor: secondary,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            textTheme: _getTextTheme(languageCode),
            iconTheme: iconTheme.copyWith(color: text.shade10, size: 16),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 0,
              scrolledUnderElevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle.light,
            ),
            floatingActionButtonTheme: floatingActionButtonTheme.copyWith(
              backgroundColor: primary,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            bottomNavigationBarTheme: bottomNavigationBarTheme.copyWith(
                backgroundColor: text.shade90,
                selectedItemColor: sunriseYellow.shade60,
                unselectedItemColor: text.shade60,
                selectedIconTheme: iconTheme.copyWith(color: sunriseYellow.shade60),
                selectedLabelStyle: _getTextTheme(languageCode).labelMedium?.copyWith(color: sunriseYellow.shade60),
                unselectedIconTheme: iconTheme.copyWith(color: text.shade60),
                unselectedLabelStyle: _getTextTheme(languageCode).labelMedium?.copyWith(color: text.shade60),
            ),
            datePickerTheme: DatePickerThemeData(
              backgroundColor: text.shade20,
              surfaceTintColor: text.shade20,
              headerHeadlineStyle: _getTextTheme(languageCode).titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              todayBackgroundColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return text.shade100;
                  }
                  return Colors.transparent;
                },
              ),
              todayForegroundColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (!states.contains(WidgetState.selected)) {
                    return text.shade100;
                  }
                  return text.shade10;
                },
              ),
              todayBorder: BorderSide(color: primary),
              weekdayStyle: _getTextTheme(languageCode).labelMedium?.copyWith(color: primary),
              dayBackgroundColor: WidgetStateProperty.resolveWith(
                (states) {
                  if (states.contains(WidgetState.selected)) {
                    return primary;
                  }
                  return Colors.transparent;
                },
              ),
              confirmButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return primary;
                  },
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return secondary;
                  },
                ),
                textStyle: WidgetStateProperty.resolveWith(
                  (states) {
                    return _getTextTheme(languageCode).labelMedium;
                  },
                ),
              ),
              cancelButtonStyle: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return primary;
                  },
                ),
                backgroundColor: WidgetStateProperty.resolveWith(
                  (states) {
                    return secondary;
                  },
                ),
                textStyle: WidgetStateProperty.resolveWith(
                  (states) {
                    return _getTextTheme(languageCode).labelMedium;
                  },
                ),
              ),
            ),
          );
  }

  TextTheme _getDefaultTextTheme(Color color, String fontFamily) {
    return textTheme.copyWith(
      displayLarge: textTheme.displayLarge?.copyWith(fontSize: 60, fontWeight: FontWeight.w700,  fontFamily: fontFamily, color: color),
      displayMedium: textTheme.displayMedium?.copyWith(fontSize: 52, fontWeight: FontWeight.w500, fontFamily: fontFamily, color: color),
      displaySmall: textTheme.displaySmall?.copyWith(fontSize: 40, fontWeight: FontWeight.w400,  fontFamily: fontFamily, color: color),
      headlineLarge: textTheme.headlineLarge?.copyWith(fontSize: 34, fontWeight: FontWeight.w400,  fontFamily: fontFamily, color: color),
      headlineMedium: textTheme.headlineMedium?.copyWith(fontSize: 28, fontWeight: FontWeight.w400,  fontFamily: fontFamily, color: color),
      headlineSmall: textTheme.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w400,  fontFamily: fontFamily, color: color),
      titleLarge: textTheme.titleLarge?.copyWith(fontSize: 20, fontWeight: FontWeight.w400,  fontFamily: fontFamily, color: color),
      titleMedium: textTheme.titleMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.w500,  fontFamily: fontFamily, color: color),
      titleSmall: textTheme.titleSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500,  fontFamily: fontFamily, color: color),
      labelLarge: textTheme.labelLarge?.copyWith(fontSize: 14, fontWeight: FontWeight.w700,  fontFamily: fontFamily, color: color),
      labelMedium: textTheme.labelMedium?.copyWith(fontSize: 12, fontWeight: FontWeight.w700,  fontFamily: fontFamily, color: color),
      labelSmall: textTheme.labelSmall?.copyWith(fontSize: 10, fontWeight: FontWeight.w700,  fontFamily: fontFamily, color: color),
      bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w400,  fontFamily: fontFamily, color: color),
      bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w400,  fontFamily: fontFamily, color: color),
      bodySmall: textTheme.bodySmall?.copyWith(fontSize: 12, fontWeight: FontWeight.w400,  fontFamily: fontFamily, color: color),
    );
  }
}
