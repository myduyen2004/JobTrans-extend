package jobtrans.model;

import java.util.List;

/**
 * @author MyDuyen
 */

public class Province {
    private String id;
    private String name;

    // Getters và Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getNameProvince(String id, List<Province> list){
        String province = null;
        for (Province province1 : list) {
            if(province1.getId().equals(id)){
                province = province1.getName();
            }
        }
        return province;
    }

    @Override
    public String toString() {
        return "Province{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
