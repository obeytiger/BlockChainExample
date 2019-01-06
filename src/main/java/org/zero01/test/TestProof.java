package org.zero01.test;
 
import org.zero01.util.Encrypt;
 
public class TestProof {
 
    public static void main(String[] args) {
 
        int x = 5;
        int y = 0;
 
        while (!new Encrypt().getSHA256((x * y) + "").endsWith("0")) {
            y++;
        }
 
        System.out.println("y=" + y);
    }
}