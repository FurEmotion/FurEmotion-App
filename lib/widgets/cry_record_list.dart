import 'package:babystory/models/cry.dart';
import 'package:flutter/material.dart';
import 'package:babystory/widgets/cry_record_item.dart';

class CryRecordList extends StatefulWidget {
  final List<Cry> cries;

  const CryRecordList({
    super.key,
    required this.cries,
  });

  @override
  State<CryRecordList> createState() => _CryRecordScrollViewState();
}

class _CryRecordScrollViewState extends State<CryRecordList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.cries.length,
      separatorBuilder: (BuildContext separatorContext, int separatorIndex) =>
          const SizedBox(height: 12),
      itemBuilder: (BuildContext itemContext, int itemIndex) {
        var renderIndex = widget.cries.length - itemIndex - 1;
        return CryRecordListItem(
            cry: widget.cries[renderIndex],
            initiallyExpanded: renderIndex == widget.cries.length - 1);
      },
    );
  }
}
