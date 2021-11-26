class ListOrder_model{
  var id;
  var cash_totol; // ราคารวม
  var cash;  // เงินสด
  var discount; // ลส่วนลด
  var net_amount; // ยอดสุดทิ
  var change; //เงินทอน
  var status;
  var status_sale;
  var paid_by;  // ชำระโดย
  var user_id;
  var customer_id;
  var branch_id;
  var created_at;

  ListOrder_model(this.id,this.cash_totol,this.cash,this.discount,this.net_amount,this.change,this.status,this.status_sale,this.paid_by,this.user_id,this.customer_id,this.branch_id,this.created_at);
}

// api 
/*
{
    "order": {
        "current_page": 1,
        "data": [
            {
                "id": 3,
                "cash_totol": 90,
                "cash": 162,
                "discount": 0,
                "net_amount": 162,
                "change": 0,
                "status": "สำเร็จ",
                "status_sale": "ขายปลีก",
                "paid_by": "เงินสด",
                "user_id": 1,
                "customer_id": null,
                "branch_id": 1,
                "created_at": "2021-10-16T17:40:04.000000Z",
                "updated_at": "2021-10-16T17:40:04.000000Z"
            },
            {
                "id": 2,
                "cash_totol": 72,
                "cash": 247,
                "discount": 0,
                "net_amount": 247,
                "change": 0,
                "status": "สำเร็จ",
                "status_sale": "ขายปลีก",
                "paid_by": "เงินสด",
                "user_id": 1,
                "customer_id": 1,
                "branch_id": 1,
                "created_at": "2021-10-11T13:12:20.000000Z",
                "updated_at": "2021-10-11T13:12:20.000000Z"
            },
            {
                "id": 1,
                "cash_totol": 85,
                "cash": 165,
                "discount": 0,
                "net_amount": 165,
                "change": 0,
                "status": "สำเร็จ",
                "status_sale": "ขายปลีก",
                "paid_by": "เงินสด",
                "user_id": 1,
                "customer_id": null,
                "branch_id": 1,
                "created_at": "2021-10-11T13:10:35.000000Z",
                "updated_at": "2021-10-11T13:10:35.000000Z"
            }
        ],
        "first_page_url": "http://tawhan.com/mtn-tawhan/public/api/order?page=1",
        "from": 1,
        "last_page": 1,
        "last_page_url": "http://tawhan.com/mtn-tawhan/public/api/order?page=1",
        "links": [
            {
                "url": null,
                "label": "pagination.previous",
                "active": false
            },
            {
                "url": "http://tawhan.com/mtn-tawhan/public/api/order?page=1",
                "label": "1",
                "active": true
            },
            {
                "url": null,
                "label": "pagination.next",
                "active": false
            }
        ],
        "next_page_url": null,
        "path": "http://tawhan.com/mtn-tawhan/public/api/order",
        "per_page": 10,
        "prev_page_url": null,
        "to": 3,
        "total": 3
    }
}

*/