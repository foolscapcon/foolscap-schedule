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
{% if debug == true %}
<!--
{{day}}
-->
{% endif %}

<table class="{{ schedule.class-type }}">
<tr>
    <th></th><!-- time -->
    <th></th>
</tr>
{% if debug == true %}<!--
{{day.hourly.time-slots}}
{{day.hourly.time-slots.first}}
{{day.hourly.time-slots[0]}}
{{day.hourly.time-slots[0][0]}}
{{day.hourly.time-slots[0][0].label}}
{{day.hourly.time-slots[1]}}
-->{% endif %}

{% for half-hour in (0..day.hourly.half-hour-slot-count) %}
{% assign hour = half-hour | divided_by: 2 | plus: day.hourly.start-time %}
{% capture hour-minutes %}{% cycle day.label: '00', '30' %}{% endcapture %}



  <tr> 
  {% capture ampm %}{% if hour >= 12 %}PM{% else %}AM{% endif %}{% endcapture %}
  {% if debug == true %}<!-- ampm:{{ampm}} hh:{{half-hour}} h:{{hour}} m:{{hour-minutes}} st:{{day.hourly.start-time}} -->{% endif %}  
    <td class="time">{% if hour > 12 %}{{ hour | minus: 12 }}{% else %} {{hour}}{% endif %}:{{ hour-minutes }} {{ampm}}
    
    
    {% for panel in day.hourly.time-slots[forloop.index0] %}
    <td class="{{panel.class}}" rowspan="{{panel.slots}}"> {{panel.label}}
    {% endfor %}
  </tr>
{% endfor %}
</table>

{% endfor %}

{% comment %}

## Friday
<table class="{{ schedule.class-type }}">
  <tr>
    <td>Writing Workshop
    <td>9:30 AM
    <td>3:00 PM
  </tr>
  <tr>
    <td>Registration
    <td>2:00 PM
    <td>8:00 PM
  </tr>
</table>

<table class="schedule">
  <tr>
    <th ></th>
    <th ><!--Columbia A--></th>
  </tr>
  <tr>
    <td class="time">4:00 PM</td>
    <td class="planned"></td>
  </tr>
  <tr>
    <td class="time">4:30 PM</td>
    <td class="planned"></td>
  </tr>
  <tr>
    <td class="time">5:00 PM</td>
    <td class="planned" rowspan="1">Opening Ceremony</td>
  </tr>
  <tr>
    <td class="time">5:30 PM</td>
    <td class="planned" rowspan="2">
    Meet to Create <a href="/events/#participatory-programming">Open Programming</a>
    </td>
  </tr>
  <tr>
    <td class="time">6:00 PM</td>

  </tr>
  <tr>
    <td class="time">6:30 PM</td>
       <td class="break" rowspan="3">Dinner (1.5 hr)</td>
  </tr>
  <tr>
    <td class="time">7:00 PM</td>
  </tr>
  <tr>
    <td class="time">7:30 PM</td>
  </tr>
  <tr>
    <td class="time">8:00 PM </td>
    <td ></td>
  </tr>
  <tr>
    <td class="time">...</td>
  </tr>
  <tr>
    <td class="time">11:30 PM</td>
    <td ></td>
  </tr>
</table>

## Saturday
<table class="schedule">
  <tr>
    <td>Registration
    <td>10:00 AM
    <td>5:30 PM
  </tr>
</table>
<table class="schedule">
  <tr>
    <th ></th>
    <th ></th>
  </tr>
  <tr>
    <td class="time">10:00 AM</td>
  </tr>
  <tr>
    <td class="time">...</td>
  </tr>
  <tr>
    <td class="time">12:00 PM</td>
    <td class="planned" rowspan="2">
    Meet to Create <a href="/events/#participatory-programming">Open Programming</a>
    </td>
  </tr>
  <tr>
    <td class="time">12:30 PM</td>
  </tr>
  <tr>
    <td class="time">1:00 PM</td>
    <td class="break" rowspan="3">Lunch (2 hr)</td>
  </tr>
  <tr>
    <td class="time">...</td>
  </tr>
  <tr>
    <td class="time">2:30 PM</td>
    <td ></td>
  </tr>
  <tr>
    <td class="time">3:00 PM ...</td>
    <td ></td>
  </tr>
  <tr>
    <td class="time">6:00 PM</td>
        <td class="break" rowspan="3">Dinner (2 hr)</td>
  </tr>
  <tr>
    <td class="time">...</td>
  </tr>
  <tr>
    <td class="time">7:30 PM</td>
  </tr>
  <tr>
    <td class="time">8:00 PM</td>
    <td ></td>
  </tr>
  <tr>
    <td class="time">...</td>
  </tr>
  <tr>
    <td class="time">11:30 PM</td>
    <td ></td>
  </tr>
</table>

## Sunday
<table>
  <tr>
    <td>Registration
    <td>10:00 AM
    <td>4:00 PM
  </tr>
</table>

<table class="schedule">
  <tr>
    <th ></th>
    <th ></th>
  </tr>
  <tr>
    <td class="time">9:00 AM</td>
    <td ></td>
  </tr>
  <tr>
    <td class="time">...</td>
  </tr>
  <tr>
    <td class="time">12:30 PM</td>
    <td class="break" rowspan="2">Lunch/<a href="/events/#banquet">Banquet</a></td>
  </tr>
  <tr>
    <td class="time">1:00 PM</td>
  </tr>
  <tr>
    <td class="time">1:30 PM</td>
    <td class="planned"><a href="/events/#auction">Foolscap Auction</a></td>
  </tr>
  <tr>
    <td class="time">2:00 PM</td>
    <td ></td>
  </tr>
  <tr>
    <td class="time">2:30 PM</td>
    <td ></td>
  </tr>
  <tr>
    <td class="time">3:00 PM</td>
    <td class="planned" rowspan="2">Closing Ceremony &amp; Foolscap Feedback</td>
  </tr>
  <tr>
    <td class="time">3:30 PM</td>
  </tr>
  <tr>
    <td class="time">4:00 PM</td>
    <td class="planned" rowspan="4"></td>
  </tr>
  <tr>
    <td class="time">4:30 PM</td>
  </tr>
  <tr>
    <td class="time">5:00 PM</td>
  </tr>
  <tr>
    <td class="time">5:30 PM</td>
  </tr>
</table>
 {% endcomment %}
