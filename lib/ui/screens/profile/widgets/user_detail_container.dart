import 'package:flutter/material.dart';


class DetailFieldData {
  String label;
  String value;
  VoidCallback? onTappingValue;
  DetailFieldData({
    required this.label,
    required this.value,
    this.onTappingValue,
  });
}

class UserDetailContainer extends StatelessWidget {
  final List<DetailFieldData> detailFieldData;

  const UserDetailContainer({
    Key? key,
    required this.detailFieldData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.withOpacity(.3),
          width: .7,
        ),
      ),
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: detailFieldData
            .map(
              (e) => Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: e == detailFieldData.last
                        ? BorderSide.none
                        : BorderSide(
                            color: Colors.grey.withOpacity(.3),
                            width: .7,
                          ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: e.onTappingValue ?? () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            e.value,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                          if (e.onTappingValue != null) SizedBox(width: 5),
                          if (e.onTappingValue != null)
                            RotatedBox(
                              quarterTurns: 2,
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18,
                                color: Colors.white70,
                              ),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
