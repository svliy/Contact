package com.warmer.web.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.warmer.web.dao.KgFeedBackMapper;
import com.warmer.web.entity.KgFeedBack;
import com.warmer.web.service.KgFeedBackService;
import org.springframework.stereotype.Service;

@Service
public class KgFeedbackServiceImpl extends ServiceImpl<KgFeedBackMapper, KgFeedBack> implements KgFeedBackService {
}
