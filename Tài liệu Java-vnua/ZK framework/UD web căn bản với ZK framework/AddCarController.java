package vnua.fita.controller;


import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.zkoss.zk.ui.Component;
import org.zkoss.zk.ui.Executions;
import org.zkoss.zk.ui.select.SelectorComposer;
import org.zkoss.zk.ui.select.annotation.Listen;
import org.zkoss.zk.ui.select.annotation.Wire;
import org.zkoss.zul.Image;
import org.zkoss.zul.Messagebox;
import org.zkoss.zul.Window;
 
public class AddCarController extends SelectorComposer<Component> {
    private static final long serialVersionUID = 1L;
     
    @Wire
    Window modalDialog;
    @Wire
    Image previewImage; // Hình ảnh ô tô
    // Khai báo thêm các thuộc tính của ô tô 
    
    
     
    // Xử lý sự kiện khi bấm nút Add trên hộp thoại thêm ô tô
    @Listen("onClick = #addCarBtn")
    public void addCar() {
        // Thêm ảnh vào thư mục img
    	saveImage();
    	
    	// Gọi phương thức của lớp tầng model để insert các trường dữ liệu vào database
    	// ??
    	
    	Messagebox.show("Ok!");
    	// Đóng hộp thoại
    	modalDialog.detach();
    	// Quay lại trang quản lý ô tô
        Executions.sendRedirect("searchMvc.zul"); 
    }
    
    private void saveImage() {
		BufferedInputStream in = null;
		BufferedOutputStream out = null;
		String imgDir = Executions.getCurrent().getDesktop().getWebApp().getRealPath("/img/");
		try {
			InputStream fin = previewImage.getContent().getStreamData();			
			in = new BufferedInputStream(fin);
			
			File file = new File(imgDir + previewImage.getContent().getName());
			
			OutputStream fout = new FileOutputStream(file);
			out = new BufferedOutputStream(fout);
			byte buffer[] = new byte[1024];
			int ch = in.read(buffer);
			while (ch != -1) {
				out.write(buffer, 0, ch);
				ch = in.read(buffer);
			}			
		} catch (IOException e) {
			throw new RuntimeException(e);
		} catch (Exception e) {
			throw new RuntimeException(e);
		} finally {
			try {
				if (out != null) 
					out.close();	
				
				if (in != null)
					in.close();
				
			} catch (IOException e) {
				throw new RuntimeException(e);
			}
		}

	}
}
