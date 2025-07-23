package jobtrans.model;

import java.util.List;

/**
 * @author MyDuyen
 */

public class District {
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

    public String getNameDistrict(String id, List<District> list){
        String district = null;
        for (District district1 : list) {
            if(district1.getId().equals(id)){
                district = district1.getName();
            }
        }
        return district;
    }
}
