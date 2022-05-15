package com.warmer.web.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.warmer.web.dao.KgDomainMapper;
import com.warmer.web.entity.KgDomain;
import com.warmer.web.service.KgDomainService;
import org.springframework.stereotype.Service;

@Service
public class KgDomainServiceImpl extends ServiceImpl<KgDomainMapper, KgDomain> implements KgDomainService {
}
