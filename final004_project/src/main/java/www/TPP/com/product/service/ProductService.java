package www.TPP.com.product.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import www.TPP.com.product.model.ProductVO;
import www.TPP.com.product.persistence.ProductMapper;

@Service
public class ProductService {
	@Autowired
	private ProductMapper productMapper;

	public ProductVO getProductByPostId(String postId) {
		return productMapper.getProductByPostId(postId);
	}

}
