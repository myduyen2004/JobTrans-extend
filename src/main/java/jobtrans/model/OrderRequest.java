package jobtrans.model;

import java.util.List;

/**
 * @author MyDuyen
 */

public class OrderRequest {
    private List<Product> products;
    private int jobId;
    private int senderId;
    private Order order;
    private String status;
    private String trackingId;

    // Getters và Setters

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public int getSenderId() {
        return senderId;
    }

    public void setSenderId(int senderId) {
        this.senderId = senderId;
    }

    public List<Product> getProducts() {
        return products;
    }

    public void setProducts(List<Product> products) {
        this.products = products;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public String getTrackingId() {
        return trackingId;
    }

    public void setTrackingId(String trackingId) {
        this.trackingId = trackingId;
    }


    public static class Product {
        private String name;
        private double weight;
        private int quantity;
        private int product_code;

        public Product() {
        }

        public Product(String name, double weight, int quantity) {
            this.name = name;
            this.weight = weight;
            this.quantity = quantity;
        }

        // Getters và Setters
        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public double getWeight() {
            return weight;
        }

        public void setWeight(double weight) {
            this.weight = weight;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public int getProduct_code() {
            return product_code;
        }

        public void setProduct_code(int product_code) {
            this.product_code = product_code;
        }

        @Override
        public String toString() {
            return "Product{" + "name=" + name + ", weight=" + weight + ", quantity=" + quantity + ", product_code=" + product_code + '}';
        }

    }

    public static class Order {
        private String note;
        private String deliver_option;
        private String address;
        private String hamlet;
        private String pick_ward;
        private String ward;
        private String transport;
        private String pick_tel;
        private String pick_option;
        private String pick_name;
        private String is_freeship;
        private int pick_money;
        private String pick_province;
        private String province;
        private String district;
        private String pick_address;
        private String name;
        private String pick_date;
        private String tel;
        private String id;
        private String pick_district;
        private int value;
        private int pick_session;
        private String booking_id;
        private List<Integer> tags;

        public Order() {
        }



        public Order(String address, String pick_ward, String ward, String pick_tel, String pick_name, String pick_province, String province, String district, String pick_address, String name, String tel, String pick_district) {
            this.address = address;
            this.pick_ward = pick_ward;
            this.ward = ward;
            this.pick_tel = pick_tel;
            this.pick_name = pick_name;
            this.pick_province = pick_province;
            this.province = province;
            this.district = district;
            this.pick_address = pick_address;
            this.name = name;
            this.tel = tel;
            this.pick_district = pick_district;
        }

        // Getters và Setters
        public String getNote() {
            return note;
        }

        public void setNote(String note) {
            this.note = note;
        }

        public String getDeliver_option() {
            return deliver_option;
        }

        public void setDeliver_option(String deliver_option) {
            this.deliver_option = deliver_option;
        }

        public String getAddress() {
            return address;
        }

        public void setAddress(String address) {
            this.address = address;
        }

        public String getHamlet() {
            return hamlet;
        }

        public void setHamlet(String hamlet) {
            this.hamlet = hamlet;
        }

        public String getPick_ward() {
            return pick_ward;
        }

        public void setPick_ward(String pick_ward) {
            this.pick_ward = pick_ward;
        }

        public String getWard() {
            return ward;
        }

        public void setWard(String ward) {
            this.ward = ward;
        }

        public String getTransport() {
            return transport;
        }

        public void setTransport(String transport) {
            this.transport = transport;
        }

        public String getPick_tel() {
            return pick_tel;
        }

        public void setPick_tel(String pick_tel) {
            this.pick_tel = pick_tel;
        }

        public String getPick_option() {
            return pick_option;
        }

        public void setPick_option(String pick_option) {
            this.pick_option = pick_option;
        }

        public String getPick_name() {
            return pick_name;
        }

        public void setPick_name(String pick_name) {
            this.pick_name = pick_name;
        }

        public String getIs_freeship() {
            return is_freeship;
        }

        public void setIs_freeship(String is_freeship) {
            this.is_freeship = is_freeship;
        }

        public int getPick_money() {
            return pick_money;
        }

        public void setPick_money(int pick_money) {
            this.pick_money = pick_money;
        }

        public String getPick_province() {
            return pick_province;
        }

        public void setPick_province(String pick_province) {
            this.pick_province = pick_province;
        }

        public String getProvince() {
            return province;
        }

        public void setProvince(String province) {
            this.province = province;
        }

        public String getDistrict() {
            return district;
        }

        public void setDistrict(String district) {
            this.district = district;
        }

        public String getPick_address() {
            return pick_address;
        }

        public void setPick_address(String pick_address) {
            this.pick_address = pick_address;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getPick_date() {
            return pick_date;
        }

        public void setPick_date(String pick_date) {
            this.pick_date = pick_date;
        }

        public String getTel() {
            return tel;
        }

        public void setTel(String tel) {
            this.tel = tel;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getPick_district() {
            return pick_district;
        }

        public void setPick_district(String pick_district) {
            this.pick_district = pick_district;
        }

        public int getValue() {
            return value;
        }

        public void setValue(int value) {
            this.value = value;
        }

        public int getPick_session() {
            return pick_session;
        }

        public void setPick_session(int pick_session) {
            this.pick_session = pick_session;
        }

        public String getBooking_id() {
            return booking_id;
        }

        public void setBooking_id(String booking_id) {
            this.booking_id = booking_id;
        }

        public List<Integer> getTags() {
            return tags;
        }

        public void setTags(List<Integer> tags) {
            this.tags = tags;
        }

        @Override
        public String toString() {
            return "Order{" + "note=" + note + ", deliver_option=" + deliver_option + ", address=" + address + ", hamlet=" + hamlet + ", pick_ward=" + pick_ward + ", ward=" + ward + ", transport=" + transport + ", pick_tel=" + pick_tel + ", pick_option=" + pick_option + ", pick_name=" + pick_name + ", is_freeship=" + is_freeship + ", pick_money=" + pick_money + ", pick_province=" + pick_province + ", province=" + province + ", district=" + district + ", pick_address=" + pick_address + ", name=" + name + ", pick_date=" + pick_date + ", tel=" + tel + ", id=" + id + ", pick_district=" + pick_district + ", value=" + value + ", pick_session=" + pick_session + ", booking_id=" + booking_id + ", tags=" + tags + '}';
        }

    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "OrderRequest{" + "products=" + products + ", order=" + order + ", status=" + status + '}';
    }


}

