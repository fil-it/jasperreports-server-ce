define(["require","underscore","common/component/list/model/ScalableListModel"],function(e){"use strict";function t(e,t,o){var n=this.get("bufferStartIndex")+t;this.selectionContains&&(o?(e.selected=!0,!this.selectionContains(e.value,n)&&this.addValueToSelection(e.value,n)):(e.selected=!1,this.selectionContains(e.value,n)&&this.removeValueFromSelection(e.value,n))),delete e.addToSelection}var o=e("underscore");e("common/component/list/model/ScalableListModel");return{afterFetchComplete:function(e,n){o.each(e,function(e,n){e&&(e.addToSelection?t.call(this,e,n,!0):o.isUndefined(e.addToSelection)||t.call(this,e,n))},this)}}});