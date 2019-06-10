<template>
  <div class="">
    <div class="container">
      <div class="content text-content">
        <h4 class="p-header">Overview</h4>
        <p>Increasing food production in a sustainable way is a global challenge of the 21<sup>st</sup> century. To do this, we need to get “more crop per drop.” This means applying precisely the amount of water a plant needs, when it needs it, to achieve the best possible yield. To achieve precise irrigation, we need to know how much water a plant is using on a daily basis, known as evapotranspiration (ET).</p>
        <p>ET is a very difficult climate and crop parameter to measure directly and yet is critical for field-level water management and irrigation scheduling, as well as assessing water budgets, water productivity, plant stress and drought.</p>

        <h6 class="p-section">Crop Water Use</h6>
        <p>ET is the sum of evaporation from the land surface plus transpiration from plants (Figure 1).</p>
        <p>Imagine tying a plastic bag around a plant in the evening (Figure 2). If you come back in the morning, there will be a thin layer of water condensation coating the inside of the bag. This water represents the water transpired by the plant for growth and photosynthesis.</p>
        <p>While this might work for a single plant, it would be infeasible to measure ET this way throughout a field with thousands of plants, or across a county with thousands of fields. So, how does a water manager, producer or other stakeholder <strong>accurately measure ET across a field or at a basin-wide scale?</strong></p>
        
        <div class="figure1n2">
          <div class="figure-container">
            <div class="figure">
              <img src="static/About_Figure1.jpg" width="350">
              <div class="figure-caption">Figure 1: ET as part of the water cycle Image Source: USGS</div>
            </div>
          </div>
          
          <div class="figure-container">
            <div class="figure">
              <img src="static/About_Figure2.png" width="240">
              <div class="figure-caption">Figure 2: Hypothetical experiment to measure transpiration</div>
            </div>
          </div>
        </div>

        <h6 class="p-section">Measuring Evapotranspiration</h6>
        <p>Advanced equipment and sensors, such as the SmartFlux eddy covariance towers developed by LI-COR Biosciences, can accurately measure ET at point locations. This information, for different crop types and climate conditions in the U.S., is consolidated in the Parallel 41 Flux Network, a geographic collection of flux towers. The name Parallel 41 comes from latitude line 41 north, which runs east to west across the central United States, corresponding to the study area and a region of significant food production.</p>
        <p>Satellite-based remote sensing can also calculate ET across hundreds of miles using mathematical models to produce physical-based ET estimates at 30-meter (~100ft) resolution. Daily ET calculations across many countries, including the United States, Brazil, India and the Middle East and North Africa region, are freely available through the <a href="https://glodet.nebraska.edu" target="_blank">Global Daily Evapotranspiration (GloDET) website</a>, a partner site to this Parallel 41 website.</p>
        <p>Combining the Parallel 41 Flux Network with the Global Daily Evapotranspiration dataset provides reliable, high-quality spatial information on daily crop water use (ET), in inches or millimeters per day, anchored by flux tower validation points (Figure 3).</p>

        <div class="has-text-centered">
          <img src="static/About_Figure3.jpg" width="700">
          <div class="has-text-weight-bold has-text-centered">Figure 3: Strategy for Measuring ET at large spatial scales</div>
        </div>


        <h4 class="p-header">Datasets Available</h4>
        <p>The Parallel 41 website provides real time measurements of ET, in inches or millimeters, at 30-minute increments. This data can also be viewed and downloaded as a daily total or in a 7-day sum. Additional information measured and recorded by the flux towers is available upon request and is useful to track climate variability and change over time, to support benchmarks, planning, goal-setting and policy. The updated equipment acquired for this network, and the resulting real-time gap filled data sets, can also more quickly and accurately model climate change scenarios and the effects on crop yield and water availability. Contact <a href="mailto:s-bsafa1@unl.edu">Babak Safa</a>, DWFI Post-Doctoral Research Associate, to request the following: carbon dioxide flux, soil heat flux, sensible heat flux, net radiation, air temperature, precipitation and other meteorological variables.</p>

        <h4 class="p-header">Citation Instructions</h4>
        <p>When using Parallel 41 datasets in your work, please provide the following citation:</p>
        <p>Robert B. Daugherty Water for Food Global Institute. (2019). Parallel 41 Flux Network. University of Nebraska. Lincoln, NE, USA. &lt;parallel41.nebraska.edu&gt;.</p>

        <br/>
        <h4 class="p-header">Development Team</h4>
        <p>The following people were key leaders for the overall Parallel 41 program. Additional partners are gratefully acknowledged on the Partners & Projects page. </p>
        <div class="columns">
          <div class="column">
            <div class="columns">
              <div class="column" style="text-align: right;">
                <img src="static/Neale.jpg" width="250">
              </div>
              <div class="column" style="margin: auto;">
                <strong>Christopher Neale, Ph.D.</strong><br/>
                Director of Research, Daugherty Water for Food Global Institute, University of Nebraska
              </div>
            </div>
          </div>
          <div class="column">
            <div class="columns">
              <div class="column" style="text-align: right;">
                <img src="static/Safa.jpg" width="250">
              </div>
              <div class="column" style="margin: auto;">
                <strong>Babak Safa, Ph.D.</strong><br/>
                Post-Doctoral Research Associate, Daugherty Water for Food Global Institute, University of Nebraska
              </div>
            </div>
          </div>
        </div>
        <div class="columns">
          <div class="column">
            <div class="columns">
              <div class="column" style="text-align: right;">
                <img src="static/Burba.jpg" width="250">
              </div>
              <div class="column" style="margin: auto;">
                <strong>George Burba, Ph.D.</strong><br/>
                Science & Strategy Fellow, LI-COR Biosciences; Global Fellow, Daugherty Water for Food Global Institute
              </div>
            </div>
          </div>
          <div class="column">
            <div class="columns">
              <div class="column" style="text-align: right;">
                <img src="static/Bodnar.jpg" width="250">
              </div>
              <div class="column" style="margin: auto;">
                <strong>Lacey Bodnar, PMP</strong><br/>
                Research Project Manager, Daugherty Water for Food Global Institute, University of Nebraska
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Vue from 'vue'

export default {
  name: 'about',
}
</script>

<style lang="scss" scoped>

.text-content {
  margin-bottom: 30px;
}

.p-header{
  font-weight: bold;
  margin-bottom: 0.5em;
  color: #05485A;
}

.p-section {
  text-decoration: underline;
}

.figure1n2 {
  text-align: center;

  .figure-container {
    width: 400px;
    height: 360px;
    display: inline-block;

    .figure {
      width: 360px;
      margin: auto;

      .figure-caption {
        font-weight: bold;
        margin-top: -5px;
      }
    }
  }
}


</style>
