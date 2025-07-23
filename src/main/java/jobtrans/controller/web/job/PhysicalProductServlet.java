package jobtrans.controller.web.job;

/**
 * @author MyDuyen
 */

import java.io.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.google.gson.*;
import jobtrans.dal.JobDAO;
import jobtrans.dal.OrderRequestDAO;
import jobtrans.model.*;
import com.google.gson.reflect.TypeToken;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

import java.util.logging.Level;
import java.util.logging.Logger;

import static java.lang.System.out;
//import jobtrans.dal.OrderRequestDAO;
//import jobtrans.model.OrderRequest;

@WebServlet(name="PhysicalProductServlet", urlPatterns={"/physical-product"})
public class PhysicalProductServlet extends HttpServlet {
    private static final String API_URL_PROVINCE = "https://open.oapi.vn/location/provinces?page=0&size=63&query=";
    private static final String API_URL_DISTRICT = "https://open.oapi.vn/location/districts/";
    private static final String API_URL_WARD = "https://open.oapi.vn/location/wards/";
    private List<Province> provinces = new ArrayList<>();
    private List<District> districts = new ArrayList<>();
    private List<Ward> wards = new ArrayList<>();
    private int jobId;
    private int senderId;
    private static final String API_URL = "http://services.giaohangtietkiem.vn/services/address/getAddressLevel4"; // Thay thế bằng URL thực tế
    private static final String API_TOKEN = "2FOw66gLvcYF4nC16hTL35aajS5yNx0XM3PNsTF"; // Thay thế bằng token thực tế
    private static final String PARTNER_CODE = "S22627298"; // Thay thế bằng partner code thực tế

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");
        switch (action) {
            case "loadForm":
                loadForm(request, response);
                break;
            case "getDistricts":
                String provinceId = request.getParameter("provinceId");
                fetchDistricts(provinceId, request, response);
                break;
            case "getWards":
                String districtId = request.getParameter("districtId");
                fetchWards(districtId, request, response);
                break;
            case "submitOfflineProduct":
                doPost(request, response);
                break;
            case "viewOfflineSubmit":
                viewSubmitOffline(request, response);
                break;
            case "viewStatusShipment":
                viewStatusShipment(request, response);
                break;

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String command = request.getParameter("command");
        switch (command) {
            case "submitOfflineProduct":
                try {
                    createOrderRequest(request, response);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }
                break;
//            case "verify-completion":
//            {
//                try {
//                    verifyCompletion(request, response);
//                } catch (Exception ex) {
//                    Logger.getLogger(OfflineProductServlet.class.getName()).log(Level.SEVERE, null, ex);
//                }
//            }
//            break;
//
//            case "sendOrderAPI":
//                sendOrderAPI(request, response);
//                break;
            default:
                throw new AssertionError();
        }
    }
    private void loadForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int jobId = Integer.parseInt(request.getParameter("jobId"));
        int senderId = Integer.parseInt(request.getParameter("senderId"));
        HttpURLConnection conn = (HttpURLConnection) new URL(API_URL_PROVINCE).openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder content = new StringBuilder();
            String inputLine;

            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();

            // Chuyển chuỗi JSON thành JsonObject
            JsonObject jsonResponse = JsonParser.parseString(content.toString()).getAsJsonObject();

            // Truy xuất mảng `data` từ JSON và ánh xạ thành List<Province>
            Gson gson = new Gson();
            provinces = gson.fromJson(jsonResponse.getAsJsonArray("data"), new TypeToken<List<Province>>(){}.getType());

            // Lưu danh sách vào request attribute và chuyển hướng tới JSP
            request.setAttribute("provinces", provinces);
            request.setAttribute("jobId", jobId);
            request.setAttribute("senderId", senderId);
            out.println(provinces);
            response.getWriter().print(provinces);
            request.getRequestDispatcher("offline-product-form.jsp").forward(request, response);

        } else {
            response.sendError(responseCode, "Error fetching provinces");
        }
    }
    private void fetchDistricts(String provinceId, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpURLConnection conn = (HttpURLConnection) new URL(API_URL_DISTRICT + provinceId + "?page=0&size=30&query=").openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder content = new StringBuilder();
            String inputLine;

            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();

            // Chuyển chuỗi JSON thành JsonObject
            JsonObject jsonResponse = JsonParser.parseString(content.toString()).getAsJsonObject();

            // Truy xuất mảng `data` từ JSON và ánh xạ thành List<District>
            Gson gson = new Gson();
            districts = gson.fromJson(jsonResponse.getAsJsonArray("data"), new TypeToken<List<District>>(){}.getType());

            // Lưu danh sách vào request attribute và chuyển hướng tới JSP hoặc trả về dưới dạng JSON
//        Province p = new Province();
//        for (Province province : provinces) {
//            if(province.getId() == null ? provinceId == null : province.getId().equals(provinceId)){
//                p = province;
//            }
//        }
//        request.setAttribute("districts", districts);
//        request.setAttribute("saveProvince", p);
//        request.setAttribute("provinces", provinces);
//        request.getRequestDispatcher("/address.jsp").forward(request, response);
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(districts));
        } else {
            response.sendError(responseCode, "Error fetching districts");
        }
    }
    private void fetchWards(String districtId, HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpURLConnection conn = (HttpURLConnection) new URL(API_URL_WARD + districtId + "?page=0&size=30&query=").openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        if (responseCode == HttpURLConnection.HTTP_OK) {
            BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
            StringBuilder content = new StringBuilder();
            String inputLine;

            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();

            // Chuyển chuỗi JSON thành JsonObject
            JsonObject jsonResponse = JsonParser.parseString(content.toString()).getAsJsonObject();

            // Truy xuất mảng `data` từ JSON và ánh xạ thành List<Ward>
            Gson gson = new Gson();
            wards = gson.fromJson(jsonResponse.getAsJsonArray("data"), new TypeToken<List<Ward>>(){}.getType());

            // Lưu danh sách vào request attribute và chuyển hướng tới JSP hoặc trả về dưới dạng JSON
            response.setContentType("application/json");
            response.getWriter().write(gson.toJson(wards));
        } else {
            response.sendError(responseCode, "Error fetching wards");
        }
    }
    private void createOrderRequest(HttpServletRequest request, HttpServletResponse response) throws IOException{
        int jobId = Integer.parseInt(request.getParameter("jobId"));
        int senderId = Integer.parseInt(request.getParameter("senderId"));
        String pickProvince = request.getParameter("pick_province");
        String pickDistrict = request.getParameter("pick_district");
        String pickWard = request.getParameter("pick_ward");
        String pickAddress = request.getParameter("pick_address");
        String pickTel = request.getParameter("pick_tel");
        String pickName = request.getParameter("pick_name");

        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String address = request.getParameter("address");
        String tel = request.getParameter("tel");
        String name = request.getParameter("name");

        String productName = request.getParameter("product_name");
        int productQuantity = Integer.parseInt(request.getParameter("product_quantity"));
        double productWeight = Double.parseDouble(request.getParameter("product_weight"));

        OrderRequest.Order order = new OrderRequest.Order();
        OrderRequest.Product product = new OrderRequest.Product();
        order = new OrderRequest.Order(address, pickWard, ward, pickTel, pickName, pickProvince, province, district, pickAddress, name, tel, pickDistrict);
        order.setHamlet("Khác");
        order.setTransport("road");
        order.setIs_freeship("1");
        order.setPick_money(47000);
//        order.setDeliver_option("none");
        order.setPick_option("cod");
        order.setValue(300000);
        order.setPick_session(2);
        order.setBooking_id("1");
//        order.setTags(Arrays.asList(1,7));
        product = new OrderRequest.Product(productName, productWeight, productQuantity);

        OrderRequest orderRequest = new OrderRequest();
        orderRequest.setOrder(order);
        List<OrderRequest.Product> products = new ArrayList<>();
        products.add(product);
        orderRequest.setProducts(products);
        orderRequest.setJobId(jobId);
        orderRequest.setSenderId(senderId);
        orderRequest.setStatus("Pending");
        OrderRequestDAO orderRequestDao = new OrderRequestDAO();
        try {
            orderRequestDao.insertShipment(orderRequest, jobId, senderId);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        OrderRequest.Order orderNew = orderRequestDao.getOrderRequestByJobIdAndSenderId(jobId, senderId).getOrder();
        orderRequest.getOrder().setId(orderNew.getId());
        Gson gson = new Gson();
        String json = gson.toJson(orderRequest);
        out.println("JSON Data: " + json);
        try (Reader reader = request.getReader()) {
            Gson gson01 = new GsonBuilder().setPrettyPrinting().create();
            OrderRequest orderRequest01 = gson.fromJson(reader, OrderRequest.class);
            // Xử lý dữ liệu theo nhu cầu
            try (CloseableHttpClient httpClient = HttpClients.createDefault()) {
                HttpPost httpPost = new HttpPost("https://services.giaohangtietkiem.vn/services/shipment/order");
                httpPost.setHeader("Content-type", "application/json");
                httpPost.setHeader("Token", "2FOw66gLvcYF4nC16hTL35aajS5yNx0XM3PNsTF");
                httpPost.setHeader("X-Client-Source", "S22627298");
                // Thêm dữ liệu JSON vào yêu cầu
                out.print(json);
                StringEntity entity = new StringEntity(json, StandardCharsets.UTF_8);
                httpPost.setEntity(entity);
                // Nhận phản hồi từ API
                HttpResponse httpResponse = httpClient.execute(httpPost);
                HttpEntity responseEntity = httpResponse.getEntity();
                String responseString = EntityUtils.toString(responseEntity, StandardCharsets.UTF_8);
                // Phân tích chuỗi JSON để lấy tracking_id
                String trackingId = null;
                JsonObject jsonResponse = gson.fromJson(responseString, JsonObject.class);
                if (jsonResponse.has("order") && jsonResponse.get("order").isJsonObject()) {
                    JsonObject order1 = jsonResponse.getAsJsonObject("order");
                    if (order1.has("tracking_id")) {
                        trackingId = order1.get("tracking_id").getAsString();
                        // Lưu trackingId và update DB
                    } else {
                        out.println("Không có 'tracking_id' trong order.");
                    }
                } else {
                    out.println("Không tìm thấy trường 'order' hoặc 'order' không phải object.");
                }
                // Trả phản hồi về client
                response.setContentType("application/json; charset=UTF-8");
                orderRequestDao.updateStatusByJobId(jobId, "Đã tạo đơn ship");
                orderRequestDao.updateTrackingId(jobId, trackingId);
                new JobDAO().updateStatusJobId(jobId, 5);
//                response.sendRedirect("https://khachhang.giaohangtietkiem.vn/web/");
                orderRequest.setTrackingId(trackingId);
                request.setAttribute("orderRequest", orderRequest);
                request.setAttribute("jobId", jobId);
                request.getRequestDispatcher("view-physical-product.jsp").forward(request, response);
            }catch(Exception e){
                out.print(e.getMessage());
            }
        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        }
    }
    private void viewSubmitOffline(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        int jobId = Integer.parseInt(request.getParameter("jobId"));
        int senderId = Integer.parseInt(request.getParameter("senderId"));
        OrderRequest orderRequest = new OrderRequest();
        OrderRequestDAO orderRequestDao = new OrderRequestDAO();
        orderRequest = orderRequestDao.getOrderRequestByJobIdAndSenderId(jobId, senderId);
        request.setAttribute("orderRequest", orderRequest);
        request.getRequestDispatcher("view-physical-product.jsp").forward(request, response);
    }
    private void viewStatusShipment(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String trackingOrder = request.getParameter("tracking_id");

        if (trackingOrder == null || trackingOrder.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tracking order is required.");
            return;
        }

        // Tạo URL để gọi API
        String apiUrl = "https://services.giaohangtietkiem.vn/services/shipment/v2/" + trackingOrder;

        try {
            // Thiết lập kết nối HTTP
            URL url = new URL(apiUrl);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            conn.setRequestProperty("Token", API_TOKEN);
            conn.setRequestProperty("X-Client-Source", PARTNER_CODE);

            // Kiểm tra mã phản hồi HTTP
            int responseCode = conn.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                // Đọc phản hồi JSON từ API
                BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream()));
                String inputLine;
                StringBuilder content = new StringBuilder();

                while ((inputLine = in.readLine()) != null) {
                    content.append(inputLine);
                }
                in.close();

                // Phân tích JSON để lấy thông tin đơn hàng
                JsonObject jsonResponse = JsonParser.parseString(content.toString()).getAsJsonObject();
                JsonObject order = jsonResponse.getAsJsonObject("order");

                // Lấy trạng thái và thông tin chi tiết
                String statusText = order.get("status_text").getAsString();
                String createdDate = order.get("created").getAsString();
                String modifiedDate = order.get("modified").getAsString();

                OrderRequestDAO orderRequestDao = new OrderRequestDAO();
                OrderRequest orderRequest = orderRequestDao.getOrderRequestByTrackingId(trackingOrder);
                // Gửi trạng thái và chi tiết đến trang JSP
                request.setAttribute("statusText", statusText);
                request.setAttribute("createdDate", createdDate);
                request.setAttribute("modifiedDate", modifiedDate);
                request.setAttribute("orderRequest", orderRequest);

                request.getRequestDispatcher("/view-physical-product-status.jsp").forward(request, response);



            } else {
                response.sendError(HttpServletResponse.SC_BAD_GATEWAY, "Failed to fetch order status from GHTK API.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print(e);
        }

    }
}
