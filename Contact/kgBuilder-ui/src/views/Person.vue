<template>
  <div class="Person">
    <el-container>
      <el-container>
        <el-aside class="el-aside" >
<!--          <el-button type="primary" @click="login" style="float: right; padding: 4px 0">退出登录</el-button>-->
          <el-col :span="24" align="center" style="padding-top: 60px;padding-bottom: 30px">
            <div class="sub-title" align="center"></div>
            <div class="demo-basic--circle" align="center">
              <div class="img" align="center">
                <el-avatar
                  :size="160"
                  :src="circleUrl"
                  align="center"
                  @error="图片加载失败"
                ></el-avatar>
              </div>
              <!--div class="block" align="center">
                <span align="center">12345678</span>
              </div-->
            </div>
          </el-col>
          <el-card class="card" shadow="hover">
            <div class="information" align="left">
                <span>用户ID：{{user.id}}</span><br>
                <span>用户昵称：{{user.nickname}}</span><br>
                <span>姓名：{{user.username}}</span><br>
                <span>性别：男</span><br>
                <span>年龄：21</span><br>
                <span>邮箱：{{user.email}}</span><br>
                <span>手机号：{{user.phone}}</span>
            </div>
          </el-card >
        </el-aside>
        <el-container>
          <el-main style="background-color: white;border: 1px solid purple;border-radius: 10px;margin-left: 10px">
             <el-card class="box-card" shadow="hover" style="margin-top: 20px">
              <div>
                <div>
                  <span><b>图谱仓库</b></span>
                </div>
                <div class="ml-a-box" style="min-height:100px">
                  <a
                    @click="matchDomainGraph(m, $event)"
                    v-for="m in pageModel.nodeList"
                    href="javascript:void(0)"
                    :title="m.name"
                  >
                    <el-tag
                      style="margin:2px;display: inline-table;background-color: white;border-color: white;color: blueviolet"
                      @close="deleteDomain(m.id, m.name)"
                    >{{ m.name | fliter1}}</el-tag
                    >
                  </a>
                </div>
              </div>
            </el-card>
            <el-card class="box-card-1" style="margin-top: 40px">
              <el-row>
                <h2>图谱信息</h2>
                <el-col :span="24"><div class="grid-content bg-purple-dark"></div></el-col>
              </el-row>
              <el-row :gutter="12">
                <el-col :span="24">
                  <el-descriptions class="margin-top" title="列表" column="1" size="medium" border>
                    <template slot="extra">
                      <el-button type="primary" size="small" @click="openGraph(val)">公开图谱</el-button>
                      <el-button type="danger" size="small" @click="closedGraph(val)">关闭图谱</el-button>
                    </template>
                    <el-descriptions-item>
                      <template slot="label">
                        <i class="el-icon-bangzhu"></i>
                        图谱名称
                      </template>
                      {{tupuname}}
                    </el-descriptions-item>
                    <el-descriptions-item>
                      <template slot="label">
                        <i class="el-icon-caret-top"></i>
                        节点数目
                      </template>
                      {{graph.nodes.length}}
                    </el-descriptions-item>
                    <el-descriptions-item>
                      <template slot="label">
                        <i class="el-icon-caret-bottom"></i>
                        关系数目
                      </template>
                      {{graph.links.length}}
                    </el-descriptions-item>
                    <el-descriptions-item>
                      <template slot="label">
                        <i class="el-icon-full-screen"></i>
                        公开
                      </template>
                      <el-tag size="small">{{isPublic}}</el-tag>
                    </el-descriptions-item>
                  </el-descriptions>
                </el-col>
              </el-row>
            </el-card>
          </el-main>
        </el-container>
      </el-container>
    </el-container>
  </div>
</template>

<script>
import {contactApi, kgBuilderApi} from "@/api";
import avatarURL from '../assets/图片3.jpg'
import * as d3 from "d3";
import _ from "lodash";
import html2canvas from "html2canvas";
import MenuBlank from "@/views/kgbuilder/components/menu_blank";
import MenuLink from "@/views/kgbuilder/components/menu_link";
import KgForm from "@/views/kgbuilder/components/kg_form";
import NodeRicher from "@/views/kgbuilder/components/node_richer";
import KgFocus from "@/components/KGFocus";
import KgJson from "@/views/kgbuilder/components/kg_json";
import KgHelp from "@/views/kgbuilder/components/kg_help";
import KgWanted from "@/components/KGWanted";
export default {
  name: 'Person',
  components: {
    user: {},
    MenuBlank,
    MenuLink,
    KgForm,
    NodeRicher,
    KgFocus,
    KgJson,
    KgHelp,
    KgWanted
  },
  data() {
    return {
      user:{
        username: ''
      },
      circleUrl: require('@/assets/touxiang.jpg'),
      tupuname: '',
      svg: null,
      timer: null,
      simulation: null,
      linkGroup: null,
      linkTextGroup: null,
      nodeGroup: null,
      nodeTextGroup: null,
      nodeSymbolGroup: null,
      nodeButtonGroup: null,
      nodeButtonAction: "",
      tooltip: null,
      mouserPos: { left: "-1000px", top: "-1000px" },
      nodeDetail: null,
      pageSizeList: [
        { size: 500, isActive: true },
        { size: 1000, isActive: false },
        { size: 2000, isActive: false },
        { size: 5000, isActive: false }
      ],
      isAddLink: false,
      isDeleteLink: false,
      selectNode: {
        nodeId: "",
        nodeName: "",
        fx: "",
        fy: ""
      },
      selectSourceNodeId: 0,
      selectTargetNodeId: 0,
      domain: "",
      domainId: 0,
      nodeName: "",
      pageSize: 500,
      activeNode: null,
      nodeImageList: [],
      showImageList: [],
      editorContent: "",
      pageModel: {
        pageIndex: 1,
        pageSize: 30,
        totalCount: 0,
        totalPage: 0,
        nodeList: []
      },
      graph: {
        nodes: [],
        links: [],
        domaindata: [
          {pub:0}
        ]
      },
      jsonShow: false,
      helpShow: false
    };
  },
  computed:{
    isPublic() {
      if(this.graph.domaindata[0].pub == 0)
        return "closed"
      else
        return "open"
    }
  },
  filters: {
    labelFormat: function(value) {
      let domain = value.substring(1, value.length - 1);
      return domain;
    },
    fliter1: function (value) {
      var index = value.indexOf("@");
      return value.substring(0, index);
    }
  },
  mounted() {
    this.$nextTick(_ => {
      this.initGraph();
    });
  },
  created() {
    this.user.username = localStorage.getItem("user") ? JSON.parse(localStorage.getItem("user")).username : "";
    console.log(this.user.username)
    contactApi.getUserByUserName(this.user.username).then((res)=>{
      this.user = res.data
    })
    this.getDomain();

  },
  methods: {
    openGraph(){
      let userId = localStorage.getItem("user")
        ? JSON.parse(localStorage.getItem("user")).id
        : "";
      if(this.isPublic == 1){
        alert("图谱已经公开")
      }else{
        var data = this.tupuname + "@" + userId
        contactApi.openDomain(data).then((res)=>{
          if(res)
            alert("图谱公开了")
        })
      }
    },
    closedGraph(){
      let userId = localStorage.getItem("user")
        ? JSON.parse(localStorage.getItem("user")).id
        : "";
      if(this.isPublic == 0){
        alert("图谱已经关闭")
      }else{
        var data = this.tupuname + "@" + userId
        console.log(data)
        contactApi.closedDomain(data).then((res)=>{
          if(res)
            alert("图谱关闭了")
        })
      }
    },
    getUser() {
      let username = localStorage.getItem("user")
        ? JSON.parse(localStorage.getItem("user")).username
        : "";
      if (username) {
        // 从后台获取User数据
        contactApi.getUserByUserName(username).then((res) => {
          // 重新赋值后台的最新User数据
          console.log(res.data)
          this.user = res.data;
        });
      }
    },
    prev() {
      if (this.pageModel.pageIndex > 1) {
        this.pageModel.pageIndex--;
        this.getDomain();
      }
    },
    next() {
      if (this.pageModel.pageIndex < this.pageModel.totalPage) {
        this.pageModel.pageIndex++;
        this.getDomain();
      }
    },
    // 初始化画布
    initGraph() {
      let graphContainer = d3.select(".graphContainer");
      let width = graphContainer._groups[0][0].offsetWidth;
      let height = window.screen.height; //
      this.svg = graphContainer.append("svg");
      this.svg.attr("width", width);
      this.svg.attr("height", height);
      this.simulation = d3
        .forceSimulation()
        .force(
          "link",
          d3
            .forceLink()
            .distance(function(d) {
              return Math.floor(Math.random() * (700 - 200)) + 200;
            })
            .id(function(d) {
              return d.uuid;
            })
        )
        .force("charge", d3.forceManyBody().strength(-400))
        .force("collide", d3.forceCollide())
        .force("center", d3.forceCenter(width / 2, (height - 200) / 2));
      this.linkGroup = this.svg.append("g").attr("class", "line");
      this.linkTextGroup = this.svg.append("g").attr("class", "lineText");
      this.nodeGroup = this.svg.append("g").attr("class", "node");
      this.nodeTextGroup = this.svg.append("g").attr("class", "nodeText");
      this.nodeSymbolGroup = this.svg.append("g").attr("class", "nodeSymbol");
      this.nodeButtonGroup = this.svg.append("g").attr("class", "nodeButton");
      this.addMaker();
      this.tooltip = this.svg.append("div").style("opacity", 0);
      this.svg.on(
        "click",
        function() {
          d3.selectAll(".buttongroup").classed("circle_none", true);
        },
        "false"
      );
    },
    // 初始化画布数据
    updateGraph() {
      let lks = this.graph.links;
      let nodes = this.graph.nodes;
      let links = [];
      //由后端传过来的节点坐标，固定节点，由于是字符串，需要转换
      nodes.forEach(function(n) {
        if (typeof n.fx == "undefined" || n.fx == "" || n.fx == null) {
          n.fx = null;
        }
        if (typeof n.fy == "undefined" || n.fy == "" || n.fy == null) {
          n.fy = null;
        }
        if (typeof n.fx == "string") n.fx = parseFloat(n.fx);
        if (typeof n.fy == "string") n.fy = parseFloat(n.fy);
        if (typeof n.r == "string") n.r = parseInt(n.r);
      });
      lks.forEach(function(m) {
        let sourceNode = nodes.filter(function(n) {
          return n.uuid === m.sourceId;
        })[0];
        if (typeof sourceNode == "undefined") return;
        let targetNode = nodes.filter(function(n) {
          return n.uuid === m.targetId;
        })[0];
        if (typeof targetNode == "undefined") return;
        links.push({ source: sourceNode.uuid, target: targetNode.uuid, lk: m });
      });
      //为每一个节点定制按钮组
      this.addNodeButton();
      if (links.length > 0) {
        _.each(links, function(link) {
          let same = _.filter(links, {
            source: link.source,
            target: link.target
          });
          let sameAlt = _.filter(links, {
            source: link.target,
            target: link.source
          });
          let sameAll = same.concat(sameAlt);
          _.each(sameAll, function(s, i) {
            s.sameIndex = i + 1;
            s.sameTotal = sameAll.length;
            s.sameTotalHalf = s.sameTotal / 2;
            s.sameUneven = s.sameTotal % 2 !== 0;
            s.sameMiddleLink =
              s.sameUneven === true &&
              Math.ceil(s.sameTotalHalf) === s.sameIndex;
            s.sameLowerHalf = s.sameIndex <= s.sameTotalHalf;
            s.sameArcDirection = 1;
            //s.sameArcDirection = s.sameLowerHalf ? 0 : 1;
            s.sameIndexCorrected = s.sameLowerHalf
              ? s.sameIndex
              : s.sameIndex - Math.ceil(s.sameTotalHalf);
          });
        });
        let maxSame = _.chain(links)
          .sortBy(function(x) {
            return x.sameTotal;
          })
          .last()
          .value().sameTotal;

        _.each(links, function(link) {
          link.maxSameHalf = Math.round(maxSame / 2);
        });
      }
      // 更新连线 links
      let link = this.linkGroup
        .selectAll(".line >path")
        .data(links, function(d) {
          return d.uuid;
        });
      link.exit().remove();
      let linkEnter = this.drawLink(link);
      link = linkEnter.merge(link);
      // 更新连线文字
      this.linkTextGroup
        .selectAll("text")
        .data(links, function(d) {
          return d.uuid;
        })
        .exit()
        .remove(); //移除多余的text dom
      let linktext = this.linkTextGroup
        .selectAll("text >textPath")
        .data(links, function(d) {
          return d.uuid;
        });
      linktext.exit().remove();
      let linkTextEnter = this.drawLinkText(linktext);
      linktext = linkTextEnter.merge(linktext).text(function(d) {
        return d.lk.name;
      });
      // 更新节点按钮组
      d3.selectAll(".nodeButton >g").remove();
      let nodeButton = this.nodeButtonGroup
        .selectAll(".nodeButton")
        .data(nodes, function(d) {
          return d;
        });
      nodeButton.exit().remove();
      let nodeButtonEnter = this.drawNodeButton(nodeButton);
      nodeButton = nodeButtonEnter.merge(nodeButton);
      // 更新节点
      let node = this.nodeGroup
        .selectAll(".node >circle")
        .data(nodes, function(d) {
          return d.uuid + "_" + d.r + "_" + d.color; //d3数据驱动，r,color是表单中的可改变项，如果此处只设置了uuid,改变项可能不生效
        });
      node.exit().remove();
      let nodeEnter = this.drawNode(node);
      node = nodeEnter.merge(node).text(function(d) {
        return d.name;
      });
      // 更新节点文字
      let nodeText = this.nodeTextGroup
        .selectAll("text")
        .data(nodes, function(d) {
          return d.uuid;
        });
      nodeText.exit().remove();
      let nodeTextEnter = this.drawNodeText(nodeText);
      nodeText = nodeTextEnter.merge(nodeText).text(function(d) {
        return d.name;
      });
      nodeText
        .append("title") // 为每个节点设置title
        .text(function(d) {
          return d.name;
        });
      // 更新节点标识
      let nodeSymbol = this.nodeSymbolGroup
        .selectAll("path")
        .data(nodes, function(d) {
          return d.uuid;
        });
      nodeSymbol.exit().remove();
      let nodeSymbolEnter = this.drawNodeSymbol(nodeSymbol);
      nodeSymbol = nodeSymbolEnter.merge(nodeSymbol);
      nodeSymbol.attr("fill", "#e15500");
      nodeSymbol.attr("display", function(d) {
        if (typeof d.hasFile != "undefined" && d.hasFile > 0) {
          return "block";
        }
        return "none";
      });
      this.simulation.nodes(nodes).on("tick", ticked);
      this.simulation.force("link").links(links);
      this.simulation.alphaTarget(1).restart();
      function linkArc(d) {
        let dx = d.target.x - d.source.x,
          dy = d.target.y - d.source.y,
          dr = Math.sqrt(dx * dx + dy * dy),
          unevenCorrection = d.sameUneven ? 0 : 0.5;
        let curvature = 2,
          arc =
            (1.0 / curvature) *
            ((dr * d.maxSameHalf) / (d.sameIndexCorrected - unevenCorrection));
        if (d.sameMiddleLink) {
          arc = 0;
        }
        let dd =
          "M" +
          d.source.x +
          "," +
          d.source.y +
          "A" +
          arc +
          "," +
          arc +
          " 0 0," +
          d.sameArcDirection +
          " " +
          d.target.x +
          "," +
          d.target.y;
        return dd;
      }

      function ticked() {
        link.attr("d", linkArc);
        // 更新节点坐标
        node
          .attr("cx", function(d) {
            return d.x;
          })
          .attr("cy", function(d) {
            return d.y;
          });
        // 更新节点操作按钮组坐标
        nodeButton
          .attr("cx", function(d) {
            return d.x;
          })
          .attr("cy", function(d) {
            return d.y;
          });
        nodeButton.attr("transform", function(d) {
          return "translate(" + d.x + "," + d.y + ") scale(1)";
        });

        // 更新文字坐标
        nodeText
          .attr("x", function(d) {
            return d.x;
          })
          .attr("y", function(d) {
            return d.y;
          });
        // 更新回形针坐标
        nodeSymbol.attr("transform", function(d) {
          return (
            "translate(" + (d.x + 8) + "," + (d.y - 30) + ") scale(0.015,0.015)"
          );
        });
      }
      // 鼠标滚轮缩放
      //this.svg.call(d3.zoom().transform, d3.zoomIdentity);//缩放至初始倍数
      this.svg.call(
        d3.zoom().on("zoom", function() {
          d3.select("#link_menubar").style("display", "none");
          d3.select("#nodeDetail").style("display", "none");
          d3.selectAll(".node").attr("transform", d3.event.transform);
          d3.selectAll(".nodeText").attr("transform", d3.event.transform);
          d3.selectAll(".line").attr("transform", d3.event.transform);
          d3.selectAll(".lineText").attr("transform", d3.event.transform);
          d3.selectAll(".nodeSymbol").attr("transform", d3.event.transform);
          d3.selectAll(".nodeButton").attr("transform", d3.event.transform);
          //this.svg.selectAll("g").attr("transform", d3.event.transform);
        })
      );
      this.svg.on("dblclick.zoom", null); // 静止双击缩放
      //按钮组事件
      let _this = this;
      this.svg.selectAll(".buttongroup").on("click", function(d, i) {
        if (_this.nodeButtonAction) {
          switch (_this.nodeButtonAction) {
            case "EDIT":
              let formNode = {
                uuid: d.uuid,
                name: d.name,
                r: d.r,
                color: d.color
              };
              _this.$refs.kg_form.initNode(
                true,
                "nodeEdit",
                formNode,
                _this.domainId
              );
              break;
            case "MORE":
              _this.getMoreNode();
              break;
            case "CHILD":
              _this.$refs.kg_form.init(true, "batchAddChild");
              break;
            case "LINK":
              _this.isAddLink = true;
              _this.selectSourceNodeId = d.uuid;
              break;
            case "DELETE":
              _this.selectNode.nodeId = d.uuid;
              let out_buttongroup_id = ".out_buttongroup_" + d.uuid + "_" + i;
              _this.deleteNode(out_buttongroup_id);
              break;
          }
          //ACTION = '';//重置 ACTION
        }
      });
      //按钮组事件绑定
      this.svg.selectAll(".action_0").on("click", function(d) {
        _this.nodeButtonAction = "EDIT";
      });
      this.svg.selectAll(".action_1").on("click", function(d) {
        _this.nodeButtonAction = "MORE";
      });
      this.svg.selectAll(".action_2").on("click", function(d) {
        _this.nodeButtonAction = "CHILD";
      });
      this.svg.selectAll(".action_3").on("click", function(d) {
        _this.nodeButtonAction = "LINK";
      });
      this.svg.selectAll(".action_4").on("click", function(d) {
        _this.nodeButtonAction = "DELETE";
      });
    },
    //创建节点
    createNode(graphNode) {
      let data = graphNode;
      data.domain = this.domain;
      let _this = this;
      kgBuilderApi.createNode(data).then(result => {
        if (result.code == 200) {
          //删除旧节点，由于我们改变的是属性，不是uuid,此处我们需要更新属性，或者删除节点重新添加
          let newNode = result.data;
          for (let i = 0; i < _this.graph.nodes.length; i++) {
            if (_this.graph.nodes[i].uuid == _this.activeNode.uuid) {
              _this.graph.nodes.splice(i, 1);
            }
          }
          _this.graph.nodes.push(newNode);
          _this.updateGraph();
        }
      });
    },
    //画布直接添加节点
    createSingleNode(left, top) {
      let data = { name: "", r: 30 };
      data.domain = this.domain;
      kgBuilderApi.createNode(data).then(result => {
        if (result.code == 200) {
          let newNode = result.data;
          _.assignIn(newNode, {
            x: left,
            y: top,
            fx: left,
            fy: top,
            r: parseInt(newNode.r)
          });
          this.graph.nodes.push(newNode);
          this.updateGraph();
        }
      });
    },
    //添加箭头
    addMaker() {
      let arrowMarker = this.svg
        .append("marker")
        .attr("id", "arrow")
        .attr("markerUnits", "strokeWidth")
        .attr("markerWidth", "20") //
        .attr("markerHeight", "20")
        .attr("viewBox", "0 -5 10 10")
        .attr("refX", "22") // 13
        .attr("refY", "0")
        .attr("orient", "auto");
      let arrow_path = "M0,-5L10,0L0,5"; // 定义箭头形状
      arrowMarker
        .append("path")
        .attr("d", arrow_path)
        .attr("fill", "#fce6d4");
    },
    //绘制节点按钮
    addNodeButton(r) {
      //先删除所有为节点自定义的按钮组
      d3.selectAll("svg >defs").remove();
      let nodes = this.graph.nodes;
      let database = [1, 1, 1, 1, 1];
      let pie = d3.pie();
      let piedata = pie(database);
      let nodeButton = this.svg.append("defs");
      nodes.forEach(function(m) {
        let nBtng = nodeButton.append("g").attr("id", "out_circle" + m.uuid); //为每一个节点定制一个按钮组，在画按钮组的时候为其指定该id
        let buttonEnter = nBtng
          .selectAll(".buttongroup")
          .data(piedata)
          .enter()
          .append("g")
          .attr("class", function(d, i) {
            return "action_" + i;
          });
        let defaultR = 30;
        if (typeof m.r == "undefined") {
          m.r = defaultR;
        }
        let arc = d3
          .arc()
          .innerRadius(m.r)
          .outerRadius(m.r + 30);
        buttonEnter
          .append("path")
          .attr("d", function(d) {
            return arc(d);
          })
          .attr("fill", "#D2D5DA")
          .style("opacity", 0.6)
          .attr("stroke", "#f0f0f4")
          .attr("stroke-width", 2);
        buttonEnter
          .append("text")
          .attr("transform", function(d, i) {
            return "translate(" + arc.centroid(d) + ")";
          })
          .attr("text-anchor", "middle")
          .text(function(d, i) {
            let zi = new Array();
            zi[0] = "编辑";
            zi[1] = "展开";
            zi[2] = "追加";
            zi[3] = "连线";
            zi[4] = "删除";
            return zi[i];
          })
          .attr("font-size", 10);
      });
    },
    //拖拽开始
    dragStarted(d) {
      if (!d3.event.active) this.simulation.alphaTarget(0.3).restart();
      d.fx = d.x;
      d.fy = d.y;
      //d.fixed = true;
    },
    //拖拽中
    dragged(d) {
      d.fx = d3.event.x;
      d.fy = d3.event.y;
    },
    //拖拽结束
    dragEnded(d) {
      if (!d3.event.active) this.simulation.alphaTarget(0);
      //d.fx = d3.event.x;
      //d.fy = d3.event.y;
      let domain = this.domain;
      let uuid = d.uuid;
      let fx = d.fx;
      let fy = d.fy;
      let data = { domain: domain, uuid: uuid, fx: fx, fy: fy };
      kgBuilderApi.updateCoordinateOfNode(data).then(result => {});
    },
    //绘制节点
    drawNode(node) {
      let _this = this;
      let nodeEnter = node.enter().append("circle");
      nodeEnter.attr("r", function(d) {
        if (typeof d.r != "undefined" && d.r != "") {
          if (typeof d.r == "string") d.r = parseInt(d.r);
          return d.r;
        }
        return 30;
      });
      nodeEnter.attr("fill", function(d) {
        if (typeof d.color != "undefined" && d.color != "") {
          return d.color;
        }
        return "#ff4500";
      });
      //nodeEnter.style("opacity", 0.8);
      nodeEnter.style("opacity", 1);
      nodeEnter.style("stroke", function(d) {
        if (typeof d.color != "undefined" && d.color != "") {
          return d.color;
        }
        return "#ff4500";
      });
      nodeEnter.style("stroke-opacity", 0.6);
      nodeEnter
        .append("title") // 为每个节点设置title
        .text(function(d) {
          return d.name;
        });
      nodeEnter.on("mouseover", function(d, i) {
        _this.nodeDetail = d;
        _this.timer = setTimeout(function() {
          _this.editorContent = "";
          _this.showImageList = [];
          _this.getNodeDetail(d.uuid, d.x, d.y);
        }, 2000);
      });
      nodeEnter.on("mouseout", function(d, i) {
        clearTimeout(_this.timer);
      });
      nodeEnter.on("dblclick", function(d) {
        _this.updateNodeName(d); // 双击更新节点名称
      });
      nodeEnter.on("mouseenter", function(d) {
        let aa = d3.select(this)._groups[0][0];
        if (aa.classList.contains("selected")) return;
        d3.select(this).style("stroke-width", "6");
      });
      nodeEnter.on("mouseleave", function(d) {
        let aa = d3.select(this)._groups[0][0];
        if (aa.classList.contains("selected")) return;
        d3.select(this).style("stroke-width", "2");
      });
      nodeEnter.on("click", function(d, i) {
        d3.select("#nodeDetail").style("display", "block");
        let out_buttongroup_id = ".out_buttongroup_" + d.uuid + "_" + i;
        _this.svg.selectAll(".buttongroup").classed("circle_none", true);
        _this.svg.selectAll(out_buttongroup_id).classed("circle_none", false);
        _this.selectNode.nodeId = d.uuid;
        _this.selectNode.name = d.name;
        _this.activeNode = d;
        // 添加连线状态
        if (_this.isAddLink) {
          _this.selectTargetNodeId = d.uuid;
          if (
            _this.selectSourceNodeId == _this.selectTargetNodeId ||
            _this.selectSourceNodeId == 0 ||
            _this.selectTargetNodeId == 0
          )
            return;
          _this.createLink(
            _this.selectSourceNodeId,
            _this.selectTargetNodeId,
            "RE"
          );
          _this.selectSourceNodeId = 0;
          _this.selectTargetNodeId = 0;
          d.fixed = false;
          d3.event.stopPropagation();
          d3.event.preventDefault();
        }
      });
      nodeEnter.call(
        d3
          .drag()
          .on("start", this.dragStarted)
          .on("drag", this.dragged)
          .on("end", this.dragEnded)
      );
      return nodeEnter;
    },
    //绘制节点文字
    drawNodeText(nodeText) {
      let _this = this;
      let nodeTextEnter = nodeText
        .enter()
        .append("text")
        .style("fill", "#fff")
        .attr("dy", 4)
        .attr("font-family", "微软雅黑")
        .attr("text-anchor", "middle")
        .text(function(d) {
          if (typeof d.name == "undefined") return "";
          let length = d.name.length;
          if (d.name.length > 4) {
            let s = d.name.slice(0, 4) + "...";
            return s;
          }
          return d.name;
        });
      // nodeTextEnter.on("mouseover", function(d, i) {

      // });

      nodeTextEnter.on("dblclick", function(d) {
        _this.updateNodeName(d); // 双击更新节点名称
      });
      nodeTextEnter.on("click", function(d) {
        _this.selectNode.nodeId = d.uuid;
        // 添加连线状态
        if (_this.isAddLink) {
          _this.selectTargetNodeId = d.uuid;
          if (
            _this.selectSourceNodeId == this.selectTargetNodeId ||
            _this.selectSourceNodeId == 0 ||
            _this.selectTargetNodeId == 0
          )
            return;
          _this.createLink(
            _this.selectSourceNodeId,
            _this.selectTargetNodeId,
            "RE"
          );
          _this.selectSourceNodeId = 0;
          _this.selectTargetNodeId = 0;
          d.fixed = false;
          d3.event.stopPropagation();
        }
      });

      return nodeTextEnter;
    },
    //给节点画上标识
    drawNodeSymbol(nodeSymbol) {
      let symbol_path =
        "M566.92736 550.580907c30.907733-34.655573 25.862827-82.445653 25.862827-104.239787 0-108.086613-87.620267-195.805867-195.577173-195.805867-49.015467 0-93.310293 18.752853-127.68256 48.564907l-0.518827-0.484693-4.980053 4.97664c-1.744213 1.64864-3.91168 2.942293-5.59104 4.72064l0.515413 0.484693-134.69696 133.727573L216.439467 534.8352l0 0 137.478827-136.31488c11.605333-10.410667 26.514773-17.298773 43.165013-17.298773 36.051627 0 65.184427 29.197653 65.184427 65.24928 0 14.032213-5.33504 26.125653-12.73856 36.829867l-131.754667 132.594347 0.515413 0.518827c-10.31168 11.578027-17.07008 26.381653-17.07008 43.066027 0 36.082347 29.16352 65.245867 65.184427 65.245867 16.684373 0 31.460693-6.724267 43.035307-17.07008l0.515413 0.512M1010.336427 343.49056c0-180.25472-145.882453-326.331733-325.911893-326.331733-80.704853 0-153.77408 30.22848-210.418347 79.0528l0.484693 0.64512c-12.352853 11.834027-20.241067 28.388693-20.241067 46.916267 0 36.051627 29.16352 65.245867 65.211733 65.245867 15.909547 0 29.876907-6.36928 41.192107-15.844693l0.38912 0.259413c33.624747-28.030293 76.301653-45.58848 123.511467-45.58848 107.99104 0 195.549867 87.6544 195.549867 195.744427 0 59.815253-27.357867 112.71168-69.51936 148.503893l0 0-319.25248 317.928107 0 0c-35.826347 42.2912-88.654507 69.710507-148.340053 69.710507-107.956907 0-195.549867-87.68512-195.549867-195.805867 0-59.753813 27.385173-112.646827 69.515947-148.43904l-92.18048-92.310187c-65.69984 59.559253-107.700907 144.913067-107.700907 240.749227 0 180.28544 145.885867 326.301013 325.915307 326.301013 95.218347 0 180.02944-41.642667 239.581867-106.827093l0.13312 0.129707 321.061547-319.962453-0.126293-0.13312C968.69376 523.615573 1010.336427 438.71232 1010.336427 343.49056L1010.336427 343.49056 1010.336427 343.49056zM1010.336427 343.49056"; // 定义回形针形状
      let nodeSymbolEnter = nodeSymbol
        .enter()
        .append("path")
        .attr("d", symbol_path);
      nodeSymbolEnter.call(
        d3
          .drag()
          .on("start", this.dragStarted)
          .on("drag", this.dragged)
          .on("end", this.dragEnded)
      );
      return nodeSymbolEnter;
    },
    //构建节点环形按钮组
    drawNodeButton(nodeButton) {
      let nodeButtonEnter = nodeButton
        .enter()
        .append("g")
        .append("use") //  为每个节点组添加一个 use 子元素
        .attr("r", function(d) {
          return d.r;
        })
        .attr("xlink:href", function(d) {
          return "#out_circle" + d.uuid;
        }) //  指定 use 引用的内容
        .attr("class", function(d, i) {
          return "buttongroup out_buttongroup_" + d.uuid + "_" + i;
        })
        .classed("circle_none", true);

      return nodeButtonEnter;
    },
    //构建连线，绑定事件
    drawLink(link) {
      let _this = this;
      let linkEnter = link
        .enter()
        .append("path")
        .attr("stroke-width", 1)
        .attr("stroke", "#fce6d4")
        .attr("fill", "none")
        .attr("id", function(d) {
          return (
            "invis_" + d.lk.sourceId + "-" + d.lk.name + "-" + d.lk.targetId
          );
        })
        .attr("marker-end", "url(#arrow)"); // 箭头
      //连线双击
      linkEnter.on("dblclick", function(d) {
        _this.selectNode.nodeId = d.lk.uuid;
        _this.updateLinkName();
      });
      //连线右键菜单
      linkEnter.on("contextmenu", function(d, p, x, z) {
        //let dd = d3.mouse(this);
        _this.selectNode.nodeId = d.lk.uuid;
        _this.selectlinkname = d.lk.name;
        var e = window.event;
        let link = {
          left: e.clientX,
          top: e.clientY,
          show: true
        };
        _this.$refs.menu_link.init(link);
        d3.event.preventDefault(); // 禁止系统默认右键
        d3.event.stopPropagation(); // 禁止空白处右键
      });
      //连线鼠标滑入
      linkEnter.on("mouseenter", function(d) {
        d3.select(this)
          .style("stroke-width", "12")
          .attr("stroke", "#ff9e9e")
          .attr("marker-end", "");
        _this.nodeDetail = d.lk;
        d3.select("#nodeDetail").style("display", "block");
      });
      //连线鼠标离开
      linkEnter.on("mouseleave", function(d) {
        d3.select(this)
          .style("stroke-width", "1")
          .attr("stroke", "#fce6d4")
          .attr("marker-end", "url(#arrow)");
      });
      return linkEnter;
    },
    //构建连线上的文字，并绑定事件
    drawLinkText(link) {
      let _this = this;
      let linkTextEnter = link
        .enter()
        .append("text")
        .style("fill", "#e3af85")
        .append("textPath")
        .attr("startOffset", "50%")
        .attr("text-anchor", "middle")
        .attr("xlink:href", function(d) {
          return (
            "#invis_" + d.lk.sourceId + "-" + d.lk.name + "-" + d.lk.targetId
          );
        })
        .style("font-size", 14)
        .text(function(d) {
          if (d.lk.name != "") {
            return d.lk.name;
          }
        });

      linkTextEnter.on("mouseover", function(d) {
        _this.selectNode.nodeId = d.lk.uuid;
        _this.selectlinkname = d.lk.name;
        var e = window.event;
        let link = {
          left: e.pageX,
          top: e.pageY,
          show: true
        };
        _this.$refs.menu_link.init(link);
      });
      return linkTextEnter;
    },
    //删除节点
    deleteNode(out_buttongroup_id) {
      let _this = this;
      _this
        .$confirm(
          "此操作将删除该节点及周边关系(不可恢复), 是否继续?",
          "三思而后行",
          {
            confirmButtonText: "确定",
            cancelButtonText: "取消",
            type: "warning"
          }
        )
        .then(function() {
          let data = { domain: _this.domain, nodeId: _this.selectNode.nodeId };
          kgBuilderApi.deleteNode(data).then(result => {
            if (result.code == 200) {
              _this.svg.selectAll(out_buttongroup_id).remove();
              let rShips = result.data;
              // 删除节点对应的关系
              for (let m = 0; m < rShips.length; m++) {
                for (let i = 0; i < _this.graph.links.length; i++) {
                  if (_this.graph.links[i].uuid == rShips[m].uuid) {
                    _this.graph.links.splice(i, 1);
                    i = i - 1;
                  }
                }
              }
              // 找到对应的节点索引
              let j = -1;
              for (let i = 0; i < _this.graph.nodes.length; i++) {
                if (_this.graph.nodes[i].uuid == _this.selectNode.nodeId) {
                  j = i;
                  break;
                }
              }
              if (j >= 0) {
                _this.selectNode.nodeId = 0;
                _this.graph.nodes.splice(j, 1); // 根据索引删除该节点
                _this.updateGraph();
                _this.$message({
                  type: "success",
                  message: "操作成功!"
                });
              }
            }
          });
        })
        .catch(function() {
          _this.$message({
            type: "info",
            message: "已取消删除"
          });
        });
    },
    //删除连线
    deleteLink() {
      let _this = this;
      _this
        .$confirm("此操作将删除该关系(不可恢复), 是否继续?", "三思而后行", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        })
        .then(function() {
          let data = { domain: _this.domain, shipId: _this.selectNode.nodeId };
          kgBuilderApi.deleteLink(data).then(result => {
            if (result.code == 200) {
              let j = -1;
              for (let i = 0; i < _this.graph.links.length; i++) {
                if (_this.graph.links[i].uuid == _this.selectNode.nodeId) {
                  j = i;
                  break;
                }
              }
              if (j >= 0) {
                _this.selectNode.nodeId = 0;
                _this.graph.links.splice(j, 1);
                _this.updateGraph();
                _this.isDeleteLink = false;
              }
            }
          });
        })
        .catch(function() {
          _this.$message({
            type: "info",
            message: "已取消删除"
          });
        });
    },
    //添加连线
    createLink(sourceId, targetId, ship) {
      let data = {
        domain: this.domain,
        sourceId: sourceId,
        targetId: targetId,
        ship: ship
      };
      kgBuilderApi.createLink(data).then(result => {
        if (result.code == 200) {
          let newShip = result.data;
          this.graph.links.push(newShip);
          this.updateGraph();
          this.isAddLink = false;
        }
      });
    },
    //更新连线名称
    updateLinkName() {
      let _this = this;
      this.$prompt("请输入关系名称", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消",
        inputValue: this.selectlinkname
      })
        .then(function(res) {
          let value = res.value;
          let data = {
            domain: _this.domain,
            shipId: _this.selectNode.nodeId,
            shipName: value
          };
          kgBuilderApi.updateLink(data).then(result => {
            if (result.code == 200) {
              let newShip = result.data;
              _this.graph.links.forEach(function(m) {
                if (m.uuid == newShip.uuid) {
                  m.name = newShip.name;
                }
              });
              _this.selectNode.nodeId = 0;
              _this.updateGraph();
              _this.isAddLink = false;
              _this.selectlinkname = "";
            }
          });
        })
        .catch(function() {
          _this.$message({
            type: "info",
            message: "取消输入"
          });
        });
    },
    //更新节点名称
    updateNodeName(d) {
      let _this = this;
      _this
        .$prompt("编辑节点名称", "提示", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          inputValue: d.name
        })
        .then(function(res) {
          let value = res.value;
          let data = { domain: _this.domain, nodeId: d.uuid, nodeName: value };
          kgBuilderApi.updateNodeName(data).then(result => {
            if (result.code == 200) {
              if (d.uuid != 0) {
                for (let i = 0; i < _this.graph.nodes.length; i++) {
                  if (_this.graph.nodes[i].uuid == d.uuid) {
                    _this.graph.nodes[i].name = value;
                  }
                }
              }
              _this.updateGraph();
              _this.$message({
                message: "操作成功",
                type: "success"
              });
            }
          });
        })
        .catch(function() {
          _this.$message({
            type: "info",
            message: "取消操作"
          });
        });
    },
    //初始化节点富文本内容
    initNodeContent() {
      let data = { domainId: this.domainId, nodeId: this.selectNode.nodeId };
      kgBuilderApi.getNodeContent(data).then(response => {
        if (response.code == 200) {
          if (response.data) {
            this.$refs.kg_form.initContent(response.data.content);
          } else {
            this.$message.warning("暂时没有更多数据");
          }
        }
      });
    },
    //初始化节点添加的图片
    initNodeImage() {
      let data = { domainId: this.domainId, nodeId: this.selectNode.nodeId };
      kgBuilderApi.getNodeImage(data).then(response => {
        if (response.code == 200) {
          if (response.data) {
            let nodeImageList = [];
            for (let i = 0; i < response.data.length; i++) {
              nodeImageList.push({
                file: response.data[i].fileName,
                imageType: response.data[i].imageType
              });
              this.$refs.kg_form.initImage(nodeImageList);
            }
          } else {
            this.$message.warning("暂时没有更多数据");
          }
        }
      });
    },
    //一次性获取富文本和图片
    getNodeDetail(nodeId, left, top) {
      let data = { domainId: this.domainId, nodeId: nodeId };
      kgBuilderApi.getNodeDetail(data).then(result => {
        if (result.code == 200) {
          if (result.data) {
            this.$refs.node_richer.init(
              result.data.content,
              result.data.imageList,
              left,
              top
            );
          } else {
            this.$message.warning("暂时没有更多数据");
          }
        }
      });
    },
    //全屏
    requestFullScreen() {
      let element = document.getElementById("graphcontainerdiv");
      let width = window.screen.width;
      let height = window.screen.height;
      this.svg.attr("width", width);
      this.svg.attr("height", height);
      if (element.requestFullscreen) {
        element.requestFullscreen();
      }
      // FireFox
      else if (element.mozRequestFullScreen) {
        element.mozRequestFullScreen();
      }
      // Chrome等
      else if (element.webkitRequestFullScreen) {
        element.webkitRequestFullScreen();
      }
      // IE11
      else if (element.msRequestFullscreen) {
        element.msRequestFullscreen();
      }
    },
    //获取图谱节点及关系
    getDomainGraph() {
      this.loading = true;
      let data = {
        domain: this.domain,
        nodeName: this.nodeName,
        pageSize: this.pageSize
      };
      kgBuilderApi.getDomainGraph(data).then(result => {
        console.log(result)
        if (result.code == 200) {
          if (result.data != null) {
            this.graph.domaindata = result.data.domaindata;
            this.graph.nodes = result.data.node;
            this.graph.links = result.data.relationship;
            this.updateGraph();
          }
        }
      });
    },
    //添加单个节点，改变鼠标样式为+
    btnAddSingle() {
      d3.select(".graphContainer").style("cursor", "crosshair"); //进入新增模式，鼠标变成＋
    },
    //删除连线
    btnDeleteLink() {
      this.isDeleteLink = true;
      d3.select(".link").attr("class", "link linkDelete"); // 修改鼠标样式为"+"
    },
    //展开更多节点
    getMoreNode() {
      let data = { domain: this.domain, nodeId: this.selectNode.nodeId };
      kgBuilderApi.getMoreRelationNode(data).then(result => {
        if (result.code == 200) {
          //把不存在于画布的节点添加到画布
          this.mergeNodeAndLink(result.data.node, result.data.relationship);
          //重新绘制
          this.updateGraph();
        }
      });
    },
    //快速添加
    btnQuickAddNode() {
      this.$refs.kg_form.init(true, "batchAdd");
    },
    //删除领域
    deleteDomain(id, value) {
      this.$confirm(
        "此操作将删除该标签及其下节点和关系(不可恢复), 是否继续?",
        "三思而后行",
        {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }
      )
        .then(function(res) {
          let data = { domainId: id, domain: value };
          kgBuilderApi.deleteDomain(data).then(result => {
            if (result.code == 200) {
              this.getDomain();
              this.domain = "";
            }
          });
        })
        .catch(function() {
          this.$message({
            type: "info",
            message: "已取消删除"
          });
        });
    },
    //创建新领域
    createDomain(value) {
      let _this = this;
      this.$prompt("请输入领域名称", "提示", {
        confirmButtonText: "确定",
        cancelButtonText: "取消"
      })
        .then(function(res) {
          let userId = localStorage.getItem("user")
            ? JSON.parse(localStorage.getItem("user")).id
            : "";
          console.log(userId)
          value = res.value + "@" + userId;
          let data = { domain: value, type: 0 };
          kgBuilderApi.createDomain(data).then(result => {
            if (result.code == 200) {
              _this.getDomain();
              _this.domain = value;
              _this.getDomainGraph();
            }
          });
        })
        .catch(function() {
          _this.$message({
            type: "info",
            message: "取消输入"
          });
        });
    },
    //获取领域标签
    getLabels(data) {
      kgBuilderApi.getDomains(data).then(result => {
        if (result.code == 200) {
          let userId = localStorage.getItem("user")
            ? JSON.parse(localStorage.getItem("user")).id
            : "";
          result.data.nodeList = result.data.nodeList.filter(function (el) {
            console.log(el)
            if(el.name.indexOf("@" + userId) > -1) return true
            return false;
          })
          console.log(result.data)
          this.pageModel = result.data;
          this.pageModel.totalPage =
            parseInt((result.data.totalCount - 1) / result.data.pageSize) + 1;
        }
      });
    },
    getDomain(pageIndex) {
      this.pageModel.pageIndex = pageIndex
        ? pageIndex
        : this.pageModel.pageIndex;
      let data = {
        pageIndex: this.pageModel.pageIndex,
        pageSize: this.pageModel.pageSize,
        command: 0
      };
      this.getLabels(data);
    },
    matchDomainGraph(domain) {
      var name = domain.name.substring(0, domain.name.indexOf("@"))
      this.tupuname = name
      this.domain = domain.name;
      this.domainId = domain.id;
      this.getDomainGraph();
      console.log(this.graph)
    },
    //保存图片
    saveImage() {
      html2canvas(document.querySelector(".graphContainer"), {
        width: document.querySelector(".graphContainer").offsetWidth, // canvas画板的宽度 一般都是要保存的那个dom的宽度
        height: document.querySelector(".graphContainer").offsetHeight, // canvas画板的高度  同上
        scale: 1
      }).then(function(canvas) {
        let a = document.createElement("a");
        a.href = canvas.toDataURL("image/png"); //将画布内的信息导出为png图片数据
        let timeStamp = Date.parse(new Date());
        a.download = timeStamp; //设定下载名称
        a.click(); //点击触发下载
      });
    },
    showJsonData() {
      this.$refs.kg_json.init();
    },
    wanted() {
      this.$refs.kg_wanted.init();
    },
    //导入图谱
    importGraph() {
      this.$refs.kg_form.init(true, "import");
    },
    exportGraph() {
      if (!this.domain || this.domain == "") {
        this.$message.warning("请选择一个领域");
        return;
      }
      let data = { domain: this.domain };
      kgBuilderApi.exportGraph(data).then(result => {
        if (result.code == 200) {
          window.location.href = result.fileName;
        }
      });
    },
    help() {
      this.$refs.kg_help.init();
    },
    //设置画布内最大的点个数
    setMatchSize(m) {
      for (let i = 0; i < this.pageSizeList.length; i++) {
        this.pageSizeList[i].isActive = false;
        if (this.pageSizeList[i].size == m.size) {
          this.pageSizeList[i].isActive = true;
        }
      }
      this.pageSize = m.size;
      this.getDomainGraph();
    },
    //合并节点和连线
    mergeNodeAndLink(newNodes, newLinks) {
      let _this = this;
      newNodes.forEach(function(m) {
        let sobj = _this.graph.nodes.find(function(x) {
          return x.uuid === m.uuid;
        });
        if (typeof sobj == "undefined") {
          _this.graph.nodes.push(m);
        }
      });
      newLinks.forEach(function(m) {
        let sobj = _this.graph.links.find(function(x) {
          return x.uuid === m.uuid;
        });
        if (typeof sobj == "undefined") {
          _this.graph.links.push(m);
        }
      });
    },
    //批量添加节点
    batchCreateNode(param) {
      let data = {
        domain: this.domain,
        sourceName: param.sourceNodeName,
        targetNames: param.targetNodeNames,
        relation: param.relation
      };
      kgBuilderApi.batchCreateNode(data).then(result => {
        if (result.code == 200) {
          //把不存在于画布的节点添加到画布
          this.mergeNodeAndLink(result.data.nodes, result.data.ships);
          //重新绘制
          this.updateGraph();
          this.$message({
            message: "操作成功",
            type: "success"
          });
        }
      });
    },
    //批量添加子节点
    batchCreateChildNode(param) {
      let data = {
        domain: this.domain,
        sourceId: this.selectNode.nodeId,
        targetNames: param.targetNodeNames,
        relation: param.relation
      };
      kgBuilderApi.batchCreateChildNode(data).then(result => {
        if (result.code == 200) {
          //把不存在于画布的节点添加到画布
          this.mergeNodeAndLink(result.data.nodes, result.data.ships);
          //重新绘制
          this.updateGraph();
          this.$message({
            message: "操作成功",
            type: "success"
          });
        }
      });
    },
    //批量添加同级节点
    batchCreateSameNode(param) {
      let data = {
        domain: this.domain,
        sourceNames: param.sourceNodeName
      };
      kgBuilderApi.batchCreateSameNode(data).then(result => {
        if (result.code == 200) {
          //把不存在于画布的节点添加到画布
          this.mergeNodeAndLink(result.data, null);
          //重新绘制
          this.updateGraph();
          this.$message({
            message: "操作成功",
            type: "success"
          });
        }
      });
    },
    //画布右击
    initContainerRightClick(event) {
      let _this = this;
      _this.mouserPos = {
        left: event.clientX,
        top: event.clientY
      };
      let menuBar = {
        left: event.clientX,
        top: event.clientY,
        show: true
      };
      _this.$refs.menu_blank.init(menuBar);
      event.preventDefault();
    },
    //画布点击
    initContainerLeftClick(event) {
      let _this = this;
      _this.mouserPos = {
        left: event.clientX,
        top: event.clientY
      };
      _this.$refs.menu_blank.init({ show: false });
      _this.$refs.menu_link.init({ show: false });
      _this.$refs.node_richer.close();
      if (event.target.tagName != "circle" && event.target.tagName != "link") {
        d3.select("#nodeDetail").style("display", "none");
      }
      let cursor = document.getElementById("graphContainer").style.cursor;
      if (cursor == "crosshair") {
        d3.select(".graphContainer").style("cursor", "");
        _this.createSingleNode(event.offsetX, event.offsetY);
      }
      event.preventDefault();
    }
  }
}
</script>

<style scoped>
.Person {
  height: calc(100vh - 100px);
  overflow: hidden;
}
.el-aside {
  line-height: 44px;
  text-align: center;
  height: calc(100vh - 100px);
  background-color: white;
  border: 1px solid purple;
  border-radius: 10px;
}
.el-main {
  height: calc(100vh - 100px);
  line-height: 36px;
  text-align: center;
  background-color: #e9eef3;
}
.text {
  font-size: 14px;
}
.item {
  margin-bottom: 18px;
}
.box-card {
  width: auto;
  border-radius: 30px;
  background-color: #c4bce8;
}
.box-card-1 {

  height: fit-content;
  margin-top: 20px;
  background-color: white;
  border: 1px solid purple;
  border-radius: 20px;
}
  .card {
    border-radius: 10px;
    background-color: #c4bce8;
    margin-left: 10px;
    margin-right: 10px;
  }
  .avatar-uploader {
  text-align: center;
  padding-bottom: 10px;
}
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #ffac40;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 138px;
  height: 138px;
  line-height: 138px;
  text-align: center;
}
</style>

