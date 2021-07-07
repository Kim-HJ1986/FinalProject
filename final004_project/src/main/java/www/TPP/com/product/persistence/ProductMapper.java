package www.TPP.com.product.persistence;

import www.TPP.com.product.model.ProductVO;

public interface ProductMapper {

	public ProductVO getProductByPostId(String postId);

}
