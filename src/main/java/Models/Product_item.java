/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

/**
 *
 * @author DucNHCE180015
 */
public class Product_item extends Product{
    private int item_id;
    private int item_quan;
    private long price;

    public Product_item(int item_id, int item_quan, long price, int pro_id, String pro_name, String pro_des, String pro_img, int pro_quan, Models.Category Category) {
        super(pro_id, pro_name, pro_des, pro_img, pro_quan, Category);
        this.item_id = item_id;
        this.item_quan = item_quan;
        this.price = price;
    }

    public Product_item(int item_id, int item_quan, long price) {
        this.item_id = item_id;
        this.item_quan = item_quan;
        this.price = price;
    }

    public Product_item() {
    }
    

    public int getItem_id() {
        return item_id;
    }

    public void setItem_id(int item_id) {
        this.item_id = item_id;
    }

    public int getItem_quan() {
        return item_quan;
    }

    public void setItem_quan(int item_quan) {
        this.item_quan = item_quan;
    }

    public long getPrice() {
        return price;
    }

    public void setPrice(long price) {
        this.price = price;
    }
    
    
}
