package jobtrans.model;

import java.util.List;

/**
 * @author MyDuyen
 */

public class Ward {
    private String id;
    private String name;

    // Getters và Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public String getNameWard(String id, List<Ward> list){
        String ward = null;
        for (Ward ward1 : list) {
            if(ward1.getId().equals(id)){
                ward = ward1.getName();
            }
        }
        return ward;
    }
}
