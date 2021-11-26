body: Padding(
        padding: const EdgeInsets.only(left: 80.0, right: 80),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Center(
                  child: Text(
                    '${widget.order.net_amount}',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Center(
                child: Text(
                  'รวมทั้งหมด',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Container(
                  // padding: EdgeInsets.only(top: 20, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: 2.0, color: Colors.grey),
                      //   bottom: BorderSide(
                      //       width: 16.0, color: Colors.lightBlue.shade900),
                      ),
                      // color: Colors.white,
                    ),
                    child: null),
              ),
              Text(
                'แคชเชียร์: ${widget.order.user_id}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'ลูกค้า:  ${widget.order.customer_id}',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Container(
                  // padding: EdgeInsets.only(top: 20, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: 2.0, color: Colors.grey),
                      //   bottom: BorderSide(
                      //       width: 16.0, color: Colors.lightBlue.shade900),
                      ),
                      // color: Colors.white,
                    ),
                    child: null),
              ),
              Expanded(
                child: FutureBuilder(
                    future: detail('${widget.title}'),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data != null) {
                        return Container(
                          child: ListView.builder(
                              // shrinkWrap: true,
                              // scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  child: Row(
                                    children: [
                                      Container(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('${snapshot.data[index].name}',
                                              style: TextStyle(fontSize: 22)),
                                          Text(
                                              '${snapshot.data[index].qty} X ${snapshot.data[index].price}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey)),
                                        ],
                                      )),
                                      Spacer(),
                                      Container(
                                          child: Column(
                                        children: [
                                          Text('',
                                              style: TextStyle(fontSize: 20)),
                                          Text('${snapshot.data[index].totol}',
                                              style: TextStyle(fontSize: 20)),
                                        ],
                                      )),
                                    ],
                                  ),
                                );
                              }),
                        );
                      } else {
                        return Container(
                          child: Center(
                            child: Text('Loding...'),
                          ),
                        );
                      }
                    }),
              ),
              Text(
                'ลูกค้า:  ${widget.order.customer_id}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'ลูกค้า:  ${widget.order.customer_id}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'ลูกค้า:  ${widget.order.customer_id}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'ลูกค้า:  ${widget.order.customer_id}',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  // padding: EdgeInsets.only(top: 20, bottom: 10),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            width: 2.0, color: Colors.grey),
                      //   bottom: BorderSide(
                      //       width: 16.0, color: Colors.lightBlue.shade900),
                      ),
                      // color: Colors.white,
                    ),
                    child: null),
              ),
            ],
          ),
        ),
      ),
    