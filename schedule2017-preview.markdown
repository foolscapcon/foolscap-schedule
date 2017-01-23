{% assign debug = true %}
<style>
.schedule .time { font-size: 75%;}
.schedule .planned {border: 1px solid black;}
.schedule .break {text-align: center; vertical-align: middle; background-color: #999;}
.schedule .openspace {text-align: center; border: 1px solid black;}
</style>
<!--
 #schedule_XX anchors in the schedule blocks
#detail_XX ancors in the detail paragraphs
so you can navigate back and forth by selecting the titles
-->
{% for day in schedule.calendar %}
## {{ day.label }}

<table class="{{ schedule.class-type }}">
<!-- all-day -->
{% for event in day.all-day %}
  <tr>
    <td>{{event.label}}
    <td>{{event.start-time}}
    <td>{{event.stop-time}}
  </tr>
{% endfor %}
</table>

<!-- hourly -->

<table class="{{ schedule.class-type }}">
    <tr>
        {% for column in schedule.columns %}
          {% if column.hide == true %}<!-- skip -->{% continue %}{% endif %}
          {% capture width %}{% if column.width != nil %}width="{{column.width}}"{% endif %}{% endcapture %}        
        <th {{width}}>{{column.label}}</th>
        {% endfor %}
    </tr>

{% for half-hour in (0..day.hourly.half-hour-slot-count) %}
{% assign hour = half-hour | divided_by: 2 | plus: day.hourly.start-time %}
{% capture hour-minutes %}{% cycle day.label: '00', '30' %}{% endcapture %}



  <tr>
  {% capture ampm %}{% if hour >= 12 %}PM{% else %}AM{% endif %}{% endcapture %}
  {% if debug == true %}<!-- ampm:{{ampm}} hh:{{half-hour}} h:{{hour}} m:{{hour-minutes}} st:{{day.hourly.start-time}} -->{% endif %}
    <td class="time">{% if hour > 12 %}{{ hour | minus: 12 }}{% else %} {{hour}}{% endif %}:{{ hour-minutes }} {{ampm}}





{% for panel in day.hourly.time-slots[forloop.index0] %}

  {% capture colspan %}{% if panel.colspan != nil %}colspan="{{panel.colspan}}"{% endif %}{% endcapture %}
    <td class="{{panel.class}}" rowspan="{{panel.slots}}" {{colspan}}> {{panel.label}}
{% endfor %}
  </tr>
{% endfor %}
</table>

{% endfor %}
