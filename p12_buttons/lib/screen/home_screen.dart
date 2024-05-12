
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              // 1. style에 해당버튼타입.styleFrom()을 보통 많이 사용
              // => 원래 style 속성은 ButtonStyle타입을 받는데, ButtonStyle 속성을 지정하는 것이 복잡하므로 간단하게 만든 것임
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shadowColor: Colors.green,    // elevation을 높여야 보인다
                elevation: 5,

                disabledBackgroundColor: Colors.grey,   // onPressed에 null을 넣어주면 버튼이 비활성화 된다. 그때 배경색
                disabledForegroundColor: Colors.red,    // onPressed에 null을 넣어주면 버튼이 비활성화 된다. 그때 전경색

                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),

                padding: EdgeInsets.all(20),
                side: BorderSide(             // 버튼 테두리
                  color: Colors.black,
                  width: 5,
                ),

                // minimumSize: Size(100, 150),
                // maximumSize: Size(100, 150),
                // fixedSize: Size(200, 150),
              ),
              child: Text("Elevated Button"),
            ),
            SizedBox(height: 20,),

            OutlinedButton(
              onPressed: () {},
              // style: OutlinedButton.styleFrom(
              //   backgroundColor: Colors.blue,
              //   foregroundColor: Colors.yellow,
              //   shadowColor: Colors.black,    // elevation이 안 먹히므로 색깔을 볼 수는 없다
              //   elevation: 5,
              // ),

              // 2. 원래대로 ButtonStyle을 지정할 수도 있다.
              // => 이때 속성 값을 지정하는 것이 좀 복잡하다. => MaterialStateProperty로 지정
              //
              // MaterialState
              // 1) hovered: 마우스 커서가 버튼 위로 올라간 상태 (MobileApp에서는 의미없음)
              // 2) focused: 텍스트 커서가 포커스 받은 상태 (TextField)
              // 3) pressed: 눌렀을 때
              // 4) selected: 선택되었을 때 (체크받스, 라디오버튼)
              // 5) dragged: 버튼이 드래그되었을 때
              // 6) scrollUnber: 다른 콤포넌트 밑으로 스크롤 되었을 때(쓸일 없다)
              // 7) disabled
              // 8) error

              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.red,
                ),
                minimumSize: MaterialStateProperty.all(
                  Size(200, 150),
                )
              ),
              child: Text("Outlined Button"),
            ),
            SizedBox(height: 20,),

            TextButton(
              onPressed: () {},

              // 3. ButtonStyle로 지정하기
              // => 이번에는 MaterialStateProperty.resolveWith() 사용
              //
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.red;
                    }
                    return Colors.black;
                  },
                ),
                foregroundColor: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Colors.yellow;
                    }
                    return Colors.white;
                  },
                ),

                minimumSize: MaterialStateProperty.resolveWith(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return Size(200, 150);
                    }
                    return Size(100, 100);
                  },
                ),
              ),
              child: Text("Text Button"),
            ),
            SizedBox(height: 20,),

            // 4. shape 설정
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                // shape: StadiumBorder(),         // OutlinedButton 기본값

                // shape: RoundedRectangleBorder(    // 직사각형 테두리(단, BorderRadius로 둥글게 깎을 수 있다
                //   borderRadius: BorderRadius.circular(10),
                // ),

                // shape: BeveledRectangleBorder(
                //   borderRadius: BorderRadius.circular(10),  // 모서리를 칼로 짤라낸 느낌
                // ),

                // shape: ContinuousRectangleBorder(           // 좀더 안정감있게 둥근 모서리 사각형(25이상 이상해짐)
                //   borderRadius: BorderRadius.circular(20),
                // ),

                shape: CircleBorder(
                  eccentricity: 1,      // 0~1, 0이면 원형, 1이면 자식을 모두 덮는 타원
                ),
              ),
              child: Text("Outlined Button (shae)"),
            ),
            SizedBox(height: 20,),

            // 5. IconButton 기본
            IconButton(
              onPressed: () {},
              iconSize: 40,
              icon: Icon(
                Icons.home,
              ),
            ),
            SizedBox(height: 20,),

            // 6. ElevatedButton/OutlinedButton/TextButton의 .icon생성자를 이용하면 아이콘이 들어있는 버튼 만들 수 있다.
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.keyboard_alt_outlined),
              label: Text("키보드"),
            ),
            SizedBox(height: 20,),

            OutlinedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.mouse_outlined),
              label: Text("마우스"),
            ),
          ],
        ),
      ),
    );
  }
}
